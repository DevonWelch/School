#ifndef LISTS_H
#define LISTS_H

/* Calendars are kept in reverse order of creation
   with newest calendars at the head of the list. */
struct calendar{
    char *name;
    struct event *events;
    struct calendar *next;
};

/* Events are kept in order by time with soonest events first. 
   New events could be inserted at any point in the list. */
struct event{
    char *description;
    time_t time;
    struct event *next;
};

/* Users are kept in any order but names must be unique. If a 
   user already exists with this name, another can not be added */
struct user {
    char *name;
    struct subscription *subscriptions;
    struct user *next;
};

/* Subscriptions are kept in order as they are added. Newest
   subscriptions are at the tail of the list */
struct subscription{
    struct calendar *calendar;
    struct subscription *next;
};

typedef struct calendar Calendar;
typedef struct event Event;
typedef struct user User;
typedef struct subscription Subscription;

// helper functions not directly related to only one command in the API
Calendar *find_calendar(Calendar *cal_list, char *cal_name);
User *find_user(User *user_list, char *user_name);
void error(char *msg);

// functions provided as the API to a calendar
int add_calendar(Calendar **cal_list_ptr, char *cal_name);
void list_calendars(Calendar *cal_list);
int add_event(Calendar *cal_list, char *cal_name, char *event_name, time_t date);
int list_events(Calendar *cal_list, char *cal_name);

int add_user(User **user_list_ptr, char *user_name);
void list_users(User *user_list);
int subscribe(User *user_list, Calendar *cal_list, char *user_name, char *cal_name);

int print_next_event(Calendar *cal_list, User * user_list, char *user_name);
int print_all_events(Calendar *cal_list, User * user_list, char *user_name);

#endif
