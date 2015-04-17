#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/signal.h>
#include <unistd.h>
#include <ctype.h>
#include "lists.h"

#define INPUT_BUFFER_SIZE 256
#define INPUT_ARG_MAX_NUM 8
#define DELIM " \n"

#ifndef PORT
#define PORT 51748
#endif

static int listenfd;

Calendar *calendar_list;
User *user_list;

//taken from sample server
struct client {
  int fd;
  struct in_addr ipaddr;
  struct client *next;
  char buffer[INPUT_BUFFER_SIZE];
  char username[INPUT_BUFFER_SIZE];
} *top = NULL;
struct client * global_p = NULL;

static void addclient(int fd, struct in_addr addr);
static void removeclient(int fd);
static void broadcast(char *s, int size);

/* 
 * Print a formatted error message to stderr.
 */
void error(char *msg) {
  fprintf(stderr, "Error: %s\n", msg);
}


/* 
 * Return a calendar time representation of the time specified
 *  in local_args. 
 *    local_argv[0] must contain hour. 
 *    local_argv[1] may contain day, otherwise use current day
 *    local_argv[2] may contain month, otherwise use current month
 *    local_argv[3] may contain day, otherwise use current year
 */
time_t convert_time(int local_argc, char** local_argv) {

  time_t rawtime;
  struct tm * info;  

  // Instead of expicitly setting the time, use the current time and then
  // change some parts of it.
  time(&rawtime);            // get the time_t represention of the current time 
  info = localtime(&rawtime);   

  // The user must set the hour.
  info->tm_hour = atof(local_argv[0]);
   
  // We don't want the current minute or second. 
  info->tm_min = 0;
  info->tm_sec = 0;

  if (local_argc > 1) {
    info->tm_mday = atof(local_argv[1]);
  }
  if (local_argc > 2) {
    // months are represented counting from 0 but most people count from 1
    info->tm_mon = atof(local_argv[2])-1;
  }
  if (local_argc > 3) {
    // tm_year is the number of years after the epoch but users enter the year AD
    info->tm_year = atof(local_argv[3])-1900;
  }

  // start off by assuming we won't be in daylight savings time
  info->tm_isdst = 0;
  mktime(info);
  // need to correct if we guessed daylight savings time incorrect since
  // mktime changes info as well as returning a value. Check it out in gdb.
  if (info->tm_isdst == 1) {
    // this means we guessed wrong about daylight savings time so correct the hour
    info->tm_hour--;
  }
  return  mktime(info);
}


/* 
 * Read and process calendar commands
 * Return:  -1 for quit command
 *          0 otherwise
 */
int process_args(int cmd_argc, char **cmd_argv, Calendar **calendar_list_ptr, User **user_list_ptr) {

  Calendar *calendar_list = *calendar_list_ptr; 
  User *user_list = *user_list_ptr;

  if (cmd_argc <= 0) {
    return 0;
  } else if (strcmp(cmd_argv[0], "quit") == 0 && cmd_argc == 1) {
    return -1;
        
  } else if (strcmp(cmd_argv[0], "add_calendar") == 0 && cmd_argc == 2) {
    if (add_calendar(calendar_list_ptr, cmd_argv[1]) == -1) {
      broadcast("Calendar by this name already exists\n", 37);
      error("Calendar by this name already exists");
    }
        
  } else if (strcmp(cmd_argv[0], "list_calendars") == 0 && cmd_argc == 1) {
    char * buf = list_calendars(calendar_list);
    broadcast(buf, strlen(buf));

  } else if (strcmp(cmd_argv[0], "add_event") == 0 && cmd_argc >= 4) {
    // Parameters for convert_time are the values in the array
    // cmd_argv but starting at cmd_argv[3]. The first 3 are not
    // part of the time.
    // So subtract these 3 from the count and pass the pointer 
    // to element 3 (where the first is element 0).
    time_t time = convert_time(cmd_argc-3, &cmd_argv[3]);

    if (add_event(calendar_list, cmd_argv[1], cmd_argv[2], time) == -1) {
      broadcast("Calendar by this name does not exist\n", 37 );
      error("Calendar by this name does not exist");
    }

  } else if (strcmp(cmd_argv[0], "list_events") == 0 && cmd_argc == 2) {
    char * buf_2 = list_events(calendar_list, cmd_argv[1]);
    if (strcmp(buf_2, "Calendar DNE\0") == 0) {
      broadcast("Calendar by this name does not exist\n", 37);
      error("Calendar by this name does not exist");
    } else {
      broadcast(buf_2, strlen(buf_2));
    }

  } else if (strcmp(cmd_argv[0], "add_user") == 0 && cmd_argc == 2) {
    if (add_user(user_list_ptr, cmd_argv[1]) == -1) {
      broadcast("User by this name already exists\n", 33);
      error("User by this name already exists");
    }

  } else if (strcmp(cmd_argv[0], "list_users") == 0 && cmd_argc == 1) {
    char * buf_3 = list_users(user_list);
    broadcast(buf_3, strlen(buf_3));
        
  } else if (strcmp(cmd_argv[0], "subscribe") == 0 && cmd_argc == 3) {
    int return_code = subscribe(user_list, calendar_list, cmd_argv[1], cmd_argv[2]);
    if (return_code == -1) {
      broadcast("User by this name does not exist\n", 33);
      error("User by this name does not exist");
    } else if (return_code == -2) {
      broadcast("Calendar by this name does not exist\n", 37);
      error("Calendar by this name does not exist");
    } else if (return_code == -3) {
      broadcast("This user is already subscribed to this calendar\n", 49);
      error("This user is already subscribed to this calendar");
    } else {
      char buf_5[INPUT_BUFFER_SIZE];
      sprintf(buf_5, "You have been subscribed to calendar %s\n", cmd_argv[2]);
      struct client *p;
      for (p = top; p; p = p->next) {
	if (strcmp(p->username, cmd_argv[1]) == 0) {
	  write(p->fd, buf_5, strlen(buf_5));
	}
      }
    }
      
  } else {
    broadcast("Incorrect syntax\n", 17);
    error("Incorrect syntax");
  }
  return 0;
}

int find_network_newline(char *buf, int inbuf) {
  int i = 0;
  while (i < inbuf) {
    if (buf[i] == '\n') {
      return i;
    }
    i ++;
  }

  return -1;
}

int main(int argc, char* argv[]) {
  void bindandlisten(void), newconnection(void), whatsup(struct client *p);

  struct client *p;

  bindandlisten();
 
  //while block mostly taken from sample server
  while(1) {
    fd_set fdlist;
    int maxfd = listenfd;
    FD_ZERO(&fdlist);
    FD_SET(listenfd, &fdlist);
    for (p = top; p; p = p->next) {
      FD_SET(p->fd, &fdlist);
      if (p->fd > maxfd)
	maxfd = p->fd;
    }
    int retval;
    retval = select(maxfd + 1, &fdlist, NULL, NULL, 0);
    if (retval < 0) {
      perror("select");
    } else {
      for (p = top; p; p = p->next) {
	if (FD_ISSET(p->fd, &fdlist)) {
	  break;
	}
      }
      /*
       * it's not very likely that more than one client will drop at
       * once, so it's not a big loss that we process only one each
       * select(); we'll get it later...
       */
      if (p) {
	global_p = p;
	whatsup(p);  /* might remove p from list, so can't be in the loop */
      }
      if (FD_ISSET(listenfd, &fdlist)){
	newconnection();
      }
    }
  }
  return 0;
}

//taken from sample server
void bindandlisten(void)  /* bind and listen, abort on error */
{
  struct sockaddr_in r;

  if ((listenfd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
    perror("socket");
    exit(1);
  }

  memset(&r, '\0', sizeof r);
  r.sin_family = AF_INET;
  r.sin_addr.s_addr = INADDR_ANY;
  r.sin_port = htons(PORT);

  int on = 1;
  int status = setsockopt(listenfd, SOL_SOCKET, SO_REUSEADDR,
			  (const char *) &on, sizeof(on));
  if(status == -1) {
    perror("setsockopt -- REUSEADDR");
  }

  if (bind(listenfd, (struct sockaddr *)&r, sizeof r)) {
    perror("bind");
    exit(1);
  }

  if (listen(listenfd, 5)) {
    perror("listen");
    exit(1);
  }
}

void whatsup(struct client *p)  /* select() said activity; check it out */
{
  char input[INPUT_BUFFER_SIZE];
  memset(&input[0], 0, INPUT_BUFFER_SIZE);

  int nbytes;

  // for holding arguments to individual commands passed to sub-procedure
  char *cmd_argv[INPUT_ARG_MAX_NUM];
  int cmd_argc;
  int buf_line;
  char in_todo[INPUT_BUFFER_SIZE];
  if ((nbytes = read(p->fd, input, sizeof(input) - 1)) > 0) {
    strcat(p->buffer, input);
    buf_line = find_network_newline(p->buffer, INPUT_BUFFER_SIZE);
    if (buf_line > -1) {
      memset(&in_todo[0], 0, INPUT_BUFFER_SIZE);
      strncat(in_todo, p->buffer, buf_line);
      memmove(p->buffer, p->buffer + (buf_line*sizeof(char)) + 1, INPUT_BUFFER_SIZE);
      if (p->username[0] == '\0') {
	strcpy(p->username, in_todo);
	broadcast("Go ahead and enter calendar commands>\n", 38);
      } else {
	// tokenize arguments
	// Notice that this tokenizing is not sophisticated enough to handle quoted arguments
	// with spaces so calendar names, event descriptions, usernames etc. can not have spaces.
	char *next_token = strtok(in_todo, DELIM);
	cmd_argc = 0;
	while (next_token != NULL) {
	  if (cmd_argc >= INPUT_ARG_MAX_NUM - 1) {
	    error("Too many arguments!");
	    cmd_argc = 0;
	    break;
	  }
	  cmd_argv[cmd_argc] = next_token;
	  cmd_argc++;
	  next_token = strtok(NULL, DELIM);
	}
	if (cmd_argc > 0 && process_args(cmd_argc, cmd_argv, &calendar_list, &user_list) == -1) {
	  //copied from else if block
	  printf("Disconnect from %s\n", inet_ntoa(p->ipaddr));
	  removeclient(p->fd);
	}
      }
      broadcast(">", 1);
    }
    //else blocks taken from sample server
  } else if (nbytes == 0) {
    printf("Disconnect from %s\n", inet_ntoa(p->ipaddr));
    removeclient(p->fd);
  } else {
    /* shouldn't happen */
    perror("read");
  }
}

static void removeclient(int fd)
{
  struct client * p;
  p = top;
  if (top->fd == fd) {
    printf("Removing client %s\n", inet_ntoa((p)->ipaddr));
    top = p->next;
    free(p);
  } 
  else {
    while (p->next->fd != fd) { 
      p = p->next;
    }
    printf("Removing client %s\n", inet_ntoa((p)->ipaddr));
    if (p->next->next == NULL) {
      free(p->next);
      p->next = NULL;
    }
    else {
      struct client * next_p = p->next->next;
      free(p->next);
      p->next = next_p;
    }
  }
}

//mostly taken from sample server
static void broadcast(char *s, int size) {
  struct client *p;
  for (p = top; p; p = p->next) {
    if (global_p->fd == p->fd) {
      write(p->fd, s, size);
    }
  }
}

//mostly taken from sample server
static void addclient(int fd, struct in_addr addr) {
  struct client *p = malloc(sizeof(struct client)); 
  p->username[0] = '\0';
  printf("Adding client %s\n", inet_ntoa(addr));
  p->fd = fd;
  p->ipaddr = addr;
  p->next = top;
  top = p;
  global_p = top;
}

void newconnection(void) 
{
  int fd;
  struct sockaddr_in r;
  socklen_t socklen = sizeof r;

  if ((fd = accept(listenfd, (struct sockaddr *)&r, &socklen)) < 0) {
    perror("accept");
  } else {
    printf("connection from %s\n", inet_ntoa(r.sin_addr));
    addclient(fd, r.sin_addr);

    broadcast("What is your user name?\n", 24);
  }
}
