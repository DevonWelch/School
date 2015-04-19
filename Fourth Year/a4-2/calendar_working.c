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
  #define PORT 51747
#endif

static int listenfd;

struct client {
    int fd;
    struct in_addr ipaddr;
    struct client *next;
} *top = NULL;

int howmany = 1;

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
            error("Calendar by this name already exists");
        }
        
    } else if (strcmp(cmd_argv[0], "list_calendars") == 0 && cmd_argc == 1) {
      //list_calendars(calendar_list);
        char * buf = list_calendars(calendar_list);
	//printf("%s\n", buf);
        broadcast(buf, strlen(buf));
	//broadcast("\r\n", 2);

    } else if (strcmp(cmd_argv[0], "add_event") == 0 && cmd_argc >= 4) {
        // Parameters for convert_time are the values in the array
        // cmd_argv but starting at cmd_argv[3]. The first 3 are not
        // part of the time.
        // So subtract these 3 from the count and pass the pointer 
        // to element 3 (where the first is element 0).
        time_t time = convert_time(cmd_argc-3, &cmd_argv[3]);

        if (add_event(calendar_list, cmd_argv[1], cmd_argv[2], time) == -1) {
           error("Calendar by this name does not exist");
        }

    } else if (strcmp(cmd_argv[0], "list_events") == 0 && cmd_argc == 2) {
      /*if (list_events(calendar_list, cmd_argv[1]) == -1) {
           error("Calendar by this name does not exist");
	   }*/
      char * buf_2 = list_events(calendar_list, cmd_argv[1]);
      //printf("%s\n", buf_2);
      broadcast(buf_2, strlen(buf_2));
      //broadcast("\r\n", 2);

    } else if (strcmp(cmd_argv[0], "add_user") == 0 && cmd_argc == 2) {
        if (add_user(user_list_ptr, cmd_argv[1]) == -1) {
                error("User by this name already exists");
        }

    } else if (strcmp(cmd_argv[0], "list_users") == 0 && cmd_argc == 1) {
        char * buf_3 = list_users(user_list);
	//printf("%s\n", buf_3);
	broadcast(buf_3, strlen(buf_3));
	//broadcast("\r\n", 2);
        
    } else if (strcmp(cmd_argv[0], "subscribe") == 0 && cmd_argc == 3) {
        int return_code = subscribe(user_list, calendar_list, cmd_argv[1], cmd_argv[2]);
        if (return_code == -1) {
           error("User by this name does not exist");
        } else if (return_code == -2) {
           error("Calendar by this name does not exist");
        } else if (return_code == -3) {
           error("This user is already subscribed to this calendar");
        }
      
    } else {
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
    int batch_mode = (argc == 2);
    char input[INPUT_BUFFER_SIZE];
    FILE *input_stream;

    void bindandlisten(void), whatsup(struct client *p);

    int fd, nbytes;
    struct sockaddr_in peer;
    socklen_t socklen;
    //char buf_3[20];
    int howmany = 1;

    struct client *p;

    // for holding arguments to individual commands passed to sub-procedure
    char *cmd_argv[INPUT_ARG_MAX_NUM];
    int cmd_argc;

    // Create the heads of the two empty data-structures 
    Calendar *calendar_list = NULL;
    User *user_list = NULL;

    if (batch_mode) {
        input_stream = fopen(argv[1], "r");
        if (input_stream == NULL) {
            perror("Error opening file");
            exit(1);
        }
    } else {
        // interactive mode 
      bindandlisten();
      socklen = sizeof(peer);
      if ((fd = accept(listenfd, (struct sockaddr *)&peer, &socklen)) < 0) {
	perror("accept");
      }
      input_stream = stdin;
    }
    
    addclient(fd, peer.sin_addr);
    char buf_4[INPUT_BUFFER_SIZE];
    buf_4[0] = '\0';
    int buf_line;
    char in_todo[INPUT_BUFFER_SIZE];

    //printf("Welcome to Calendar!\nPlease type a command:\n>");
    broadcast("Welcome to Calendar!\nPlease type a command:\n>", 45);
    //sprintf(buf_4, "Dear %s,\r\n", inet_ntoa(peer.sin_addr));
    //broadcast(buf_4, strlen(buf_4));
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
      if ((retval = select(maxfd + 1, &fdlist, NULL, NULL, 0)) < 0) {
	perror("select");
      }
      //else if (retval == 0){
	//while (fgets(input, INPUT_BUFFER_SIZE, input_stream) != NULL) {
	while ((nbytes = read(fd, input, sizeof(input) - 1)) > 0) {
	  strcat(buf_4, input);
	  buf_line = find_network_newline(buf_4, INPUT_BUFFER_SIZE);
	  //printf("%s\n", input);
	  memset(&input[0], 0, INPUT_BUFFER_SIZE);
	  //printf("%s", buf_4);
	  //printf("%s\n", input);
	  if (buf_line > -1) {
	    memset(&in_todo[0], 0, INPUT_BUFFER_SIZE);
	    strncat(in_todo, buf_4, buf_line);
	    //printf("%s", buf_4);
	    memmove(buf_4, buf_4 + (buf_line*sizeof(char)) + 1, INPUT_BUFFER_SIZE);
	    //printf("%s", buf_4);
	    //printf("%d\n", buf_line);
	    // only echo the line in batch mode since in interactive mode the user
	    // just typed the line
	    if (batch_mode) {
	      printf("%s", in_todo);
	    }
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
	      break; // can only reach if quit command was entered
	    }
	    //printf(">");
	    broadcast(">", 1);
	  }
	  //	}
      }
    }
    if (batch_mode) {
        fclose(input_stream);
    }
    return 0;
 }

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
    char garbage[80];
    int len = read(p->fd, garbage, sizeof garbage);
    if (len > 0) {
        /* discard (probably more of the "yes!!!!" string) */
    } else if (len == 0) {
        char buf[80];
        printf("Disconnect from %s\n", inet_ntoa(p->ipaddr));
        fflush(stdout);
        sprintf(buf, "Goodbye %s\r\n", inet_ntoa(p->ipaddr));
        removeclient(p->fd);
        broadcast(buf, strlen(buf));
    } else {
        /* shouldn't happen */
        perror("read");
    }
}

static void removeclient(int fd)
{
    struct client **p;
    for (p = &top; *p && (*p)->fd != fd; p = &(*p)->next)
        ;
    if (*p) {
        struct client *t = (*p)->next;
        printf("Removing client %s\n", inet_ntoa((*p)->ipaddr));
        fflush(stdout);
        free(*p);
        *p = t;
        howmany--;
    } else {
        fprintf(stderr, "Trying to remove fd %d, but I don't know about it\n", fd);
        fflush(stderr);
    }
}


static void broadcast(char *s, int size)
{
    struct client *p;
    for (p = top; p; p = p->next)
        write(p->fd, s, size);
        /* should probably check write() return value and perhaps remove client */
}

static void addclient(int fd, struct in_addr addr)
{
    struct client *p = malloc(sizeof(struct client));
    if (!p) {
        fprintf(stderr, "out of memory!\n");  /* highly unlikely to happen */
        exit(1);
    }
    printf("Adding client %s\n", inet_ntoa(addr));
    fflush(stdout);
    p->fd = fd;
    p->ipaddr = addr;
    p->next = top;
    top = p;
    howmany++;
}
