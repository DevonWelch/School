#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "lists.h"

#define INPUT_BUFFER_SIZE 256
#define INPUT_ARG_MAX_NUM 8
#define DELIM " \n"


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
        list_calendars(calendar_list);
        
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
        if (list_events(calendar_list, cmd_argv[1]) == -1) {
           error("Calendar by this name does not exist");
        }

    } else if (strcmp(cmd_argv[0], "add_user") == 0 && cmd_argc == 2) {
        if (add_user(user_list_ptr, cmd_argv[1]) == -1) {
                error("User by this name already exists");
        }

    } else if (strcmp(cmd_argv[0], "list_users") == 0 && cmd_argc == 1) {
        list_users(user_list);
        
    } else if (strcmp(cmd_argv[0], "subscribe") == 0 && cmd_argc == 3) {
        int return_code = subscribe(user_list, calendar_list, cmd_argv[1], cmd_argv[2]);
        if (return_code == -1) {
           error("User by this name does not exist");
        } else if (return_code == -2) {
           error("Calendar by this name does not exist");
        } else if (return_code == -3) {
           error("This user is already subscribed to this calendar");
        }
      
    } else if (strcmp(cmd_argv[0], "next_event") == 0 && cmd_argc == 2) {
        if (print_next_event(calendar_list, user_list, cmd_argv[1]) == -1) {
           error("User by this username does not exist");
        }

    } else if (strcmp(cmd_argv[0], "print_all_events") == 0 && cmd_argc == 2) {
        if (print_all_events(calendar_list, user_list, cmd_argv[1]) == -1) {
           error("User by this username does not exist");
        }

    } else {
        error("Incorrect syntax");
    }
    return 0;
}


int main(int argc, char* argv[]) {
    int batch_mode = (argc == 2);
    char input[INPUT_BUFFER_SIZE];
    FILE *input_stream;

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
        input_stream = stdin;
    }

    printf("Welcome to Calendar!\nPlease type a command:\n>");
    
    while (fgets(input, INPUT_BUFFER_SIZE, input_stream) != NULL) {
        // only echo the line in batch mode since in interactive mode the user
        // just typed the line
        if (batch_mode) {
            printf("%s", input);
        }
        // tokenize arguments
        // Notice that this tokenizing is not sophisticated enough to handle quoted arguments
        // with spaces so calendar names, event descriptions, usernames etc. can not have spaces.
        char *next_token = strtok(input, DELIM);
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
        printf(">");
    }

    if (batch_mode) {
        fclose(input_stream);
    }
    return 0;
 }
