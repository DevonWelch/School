#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "lists.h"
#define CHAR_PT_SIZE 256*sizeof(char)

int get_next_event(Event * prev_ev, User * user_list, char * user_name);

/*
 * Return a pointer to the struct calendar with name cal_name
 * or NULL if no calendar with this name exists in the cal_list
 */
Calendar *find_calendar(Calendar *cal_list, char *cal_name) {
  Calendar *cal = cal_list;

  while (cal != NULL) {

    if (strcmp(cal->name, cal_name) == 0) {
      return cal;
    }
    cal = cal->next;

  }
  return NULL;
}


/* 
 * Return a pointer to the user with name username or NULL
 *   if no such user exists in user_list 
 */
User *find_user(User *user_list, char *username) {
  User *usr = user_list;

  while (usr != NULL) {

    if (strcmp(usr->name, username) == 0) {
      return usr;
    }
    usr = usr->next;

  }
  return NULL;
}


/* 
 * If a calendar with name cal_name does not exist, create a new
 * calendar by this name and insert it at the front of the calendar list.
 * Return values:
 *    0 if successful
 *   -1 if a calendar by cal_name already exists
 */
int add_calendar(Calendar **cal_list_ptr, char *cal_name) {
  Calendar * cal;
  if ((cal = malloc(sizeof(Calendar))) == NULL) {
    perror("malloc");
    exit(1);
  }
  cal = *cal_list_ptr;

  if (cal == NULL) { 

    //If there are currently no calendars, initialize the cal_list.
    if ((*cal_list_ptr = malloc(sizeof(Calendar))) == NULL) {
      perror("malloc");
      exit(1);
    }
    if (((*cal_list_ptr)->name = malloc(CHAR_PT_SIZE)) == NULL) {
      perror("malloc");
      exit(1);
    }
    strcpy((*cal_list_ptr)->name, cal_name);
    return 0;

  }

  while (cal != NULL) {

    //Check that there is no calendar with the given name.
    if (strcmp(cal->name, cal_name) == 0) {
      return -1;
    }
    cal = cal->next;

  }

  //Return to the beginning of the list, because that is where to put
  //a new calendar.
  cal = *cal_list_ptr;

  Calendar * new_cal_ptr;
  if ((new_cal_ptr = malloc(sizeof(Calendar))) == NULL) {
    perror("malloc");
    exit(1);
  }
  if ((new_cal_ptr->name = malloc(CHAR_PT_SIZE)) == NULL) {
    perror("malloc");
    exit(1);
  }
  strcpy(new_cal_ptr->name, cal_name);
  if ((new_cal_ptr->next = malloc(sizeof(Calendar))) == NULL) {
    perror("malloc");
    exit(1);
  }

  new_cal_ptr->next = cal;
  *cal_list_ptr = new_cal_ptr;

  return 0;
}



/* 
 * Print to stdout a list of all current calendar names (one per line)
 */
void list_calendars(Calendar *cal_list) {
  Calendar * cal = cal_list;

  while (cal != NULL) {
    printf("%s\n", cal->name);
    cal = cal->next;
  }

}


/* 
 * If a user with name username does not exist, create a new
 * user by this name and insert it at the end of the user list.
 * Return values:
 *    0 if successful
 *   -1 if username already exists
 */
int add_user(User **user_list_ptr, char *username) {
  User * usr;
  if ((usr = malloc(sizeof(User))) == NULL) {
    perror("malloc");
    exit(1);
  }

  usr = *user_list_ptr;
  if (usr == NULL) {

    //If there are currently no users, initialize the user_list.
    if ((*user_list_ptr = malloc(sizeof(User))) == NULL) {
      perror("malloc");
      exit(1);
    }
    if (((*user_list_ptr)->name = malloc(CHAR_PT_SIZE)) == NULL) {
      perror("malloc");
      exit(1);
    }
    strcpy((*user_list_ptr)->name, username);
    if (((*user_list_ptr)->subscriptions = malloc(sizeof(Subscription))) == NULL) {
      perror("malloc");
      exit(1);
    }
    (*user_list_ptr)->subscriptions = NULL;
    if (((*user_list_ptr)->next = malloc(sizeof(User))) == NULL) {
      perror("malloc");
      exit(1);
    }
    (*user_list_ptr)->next = NULL;
    return 0;

  }

  while (usr->next != NULL) {

    //Check that there is no user with the given name.
    if (strcmp(usr->name, username) == 0) {
      return -1;
    }
    usr = usr->next;

  }
  //I decided to add new users to the end of the user list, and so I do not
  //want to actually leave the list by going to null, or I would not be able to append
  //the new user. The while loop reaches the last user, and the next if
  //statement checks that that user does not have the given name. 
  if (strcmp(usr->name, username) == 0) {
    return -1;
  }

  User * new_usr_ptr;
  if ((new_usr_ptr = malloc(sizeof(User))) == NULL) {
    perror("malloc");
    exit(1);
  }
  if ((new_usr_ptr->name = malloc(CHAR_PT_SIZE)) == NULL) {
    perror("malloc");
    exit(1);
  }
  strcpy(new_usr_ptr->name, username);
  if ((new_usr_ptr->next = malloc(sizeof(User))) == NULL) {
    perror("malloc");
    exit(1);
  }
  new_usr_ptr->next = NULL;
  if ((new_usr_ptr->subscriptions = malloc(sizeof(Subscription))) == NULL) {
    perror("malloc");
    exit(1);
  }

  new_usr_ptr->subscriptions = NULL;
  usr->next = new_usr_ptr;

  return 0;
}


/* 
 * Print to stdout a list of usernames one per line 
 */
void list_users(User *user_list) {
  User * usr = user_list;
  while (usr != NULL) {
    printf("%s\n", usr->name);
    usr = usr->next;
  }
}


/*
 * Subscribe the user username to calendar cal_name
 * Return:
 *    0 if successful
 *   -1 if no user exists by this name
 *   -2 if no calendar exists by this name
 *   -3 if this user is already subscribed to this calendar
 */
int subscribe(User *user_list, Calendar *cal_list, char *username, char *cal_name) {
  User * usr = find_user(user_list, username);
  if (usr == NULL) {
    return -1;
  }

  Calendar * cal = find_calendar(cal_list, cal_name);
  if (cal == NULL) {
    return -2;
  }

  Subscription * sub = usr->subscriptions;

  if (sub == NULL) {

    //If this user has no subscriptions, initialize their subscriptions.
    Subscription * sub_ptr;
    if ((sub_ptr = malloc(sizeof(Subscription))) == NULL) {
      perror("malloc");
      exit(1);
    }
    if ((sub_ptr->calendar = malloc(sizeof(Calendar))) == NULL) {
      perror("malloc");
      exit(1);
    }
    sub_ptr->calendar = cal;
    usr->subscriptions = sub_ptr;
    return 0;

  }

  while (sub->next != NULL) {

    if (strcmp((sub->calendar)->name, cal_name) == 0) {
      return -3;
    }
    sub = sub->next;

  }
  //I decided to add new subscriptions to the end of the subscription list, and so I do not
  //want to actually leave the list by going to null, or I would not be able to append
  //the new subscription. The while loop reaches the last subscription, and the next if
  //statement checks that that subscription's calendar is not the one to be added. 
  if (strcmp((sub->calendar)->name, cal_name) == 0) {
    return -3;
  }

  Subscription * new_sub_ptr;
  if ((new_sub_ptr = malloc(sizeof(Subscription))) == NULL) {
    perror("malloc");
    exit(1);
  }
  if ((new_sub_ptr->calendar = malloc(sizeof(Calendar))) == NULL) {
    perror("malloc");
    exit(1);
  }
  new_sub_ptr->calendar = cal;
  if ((new_sub_ptr->next = malloc(sizeof(Calendar))) == NULL) {
    perror("malloc");
    exit(1);
  }

  new_sub_ptr->next = NULL;
  sub->next = new_sub_ptr;

  return 0;
}


/* 
 * Add an event with this name and date to the calender with name cal_name 
 *  Return:
 *   0 for success
 *  -1 for calendar does not exist by this name
 */
int add_event(Calendar *cal_list, char *cal_name, char *event_name, time_t time) {
  Calendar * cal;
  if ((cal = malloc(sizeof(Calendar))) == NULL) {
    perror("malloc");
    exit(1);
  }
  cal = find_calendar(cal_list, cal_name);
  if (cal == NULL) {
    return -1;
  }

  //If this calendar has no events, initialize its events.
  if (cal->events == NULL) {

    if ((cal->events = malloc(sizeof(Event))) == NULL) {
      perror("malloc");
      exit(1);
    }

    if (((cal->events)->description = malloc(CHAR_PT_SIZE)) == NULL) {
      perror("malloc");
      exit(1);
    }

    strcpy((cal->events)->description, event_name);
    (cal->events)->time = time;
  } 

  else {
    Event * evs;
    if ((evs = malloc(sizeof(Event))) == NULL) {
      perror("malloc");
      exit(1);
    }
    evs = cal->events;
    //Check if the first event is later than the new event;
    //if it is, put the new event at the beginning of the calendar's
    //events; else, search through the list for where to put it.
    if (difftime(time, evs->time) < difftime(time, time)) {

      Event * new_ev_ptr;
      if ((new_ev_ptr = malloc(sizeof (Event))) == NULL) {
	perror("malloc");
	exit(1);
      }
      if ((new_ev_ptr->description = malloc(CHAR_PT_SIZE)) == NULL) {
	perror("malloc");
	exit(1);
      }
      new_ev_ptr->time = time;
      strcpy(new_ev_ptr->description, event_name);
      if ((new_ev_ptr->next = malloc(sizeof(Calendar))) == NULL) {
	perror("malloc");
	exit(1);
      }
      new_ev_ptr->next = cal->events;
      cal->events = new_ev_ptr;
      return 0;
    }

    while (evs->next != NULL && difftime(time, (evs->next)->time) > difftime(time, time)) {
      evs = evs->next;
    }

    Event * new_ev_ptr;
    if ((new_ev_ptr = malloc(sizeof(Event))) == NULL) {
      perror("malloc");
      exit(1);
    }
    if ((new_ev_ptr->description = malloc(CHAR_PT_SIZE)) == NULL) {
      perror("malloc");
      exit(1);
    }
    new_ev_ptr->time = time;
    strcpy(new_ev_ptr->description, event_name);
    if ((new_ev_ptr->next = malloc(sizeof(Calendar))) == NULL) {
      perror("malloc");
      exit(1);
    }
    new_ev_ptr->next = evs->next;
    evs->next = new_ev_ptr;
  //End of the else block.
  }

  return 0;
}


/* 
 * Print to stdout a list of the events in this calendar ordered by time
 *  Return:
 *     0 if successful
 *    -1 if no calendar exists by this name
 */
int list_events(Calendar *cal_list, char *cal_name) {
  Calendar *cal = cal_list;

  while (cal != NULL) {

    if (strcmp(cal->name, cal_name) == 0) {
      Event * evs = cal->events;

      //Because events are already ordered by time, simply going through and printing
      //the first event, then the enxt event, etc. will accomplish the task.
      while (evs != NULL) {
	printf("%s: %s", evs->description, asctime(localtime(&(evs->time))));
	evs = evs->next;
      }

      return 0;
    }

    cal = cal->next;
  }

  return -1;
}


/* 
 * Print to stdout, the description and time of the next event for 
 * user user_name
 *  Return:
 *   0 on success
 *   -1 if this user_name does not exist or has no events
 */
int print_next_event(Calendar *cal_list, User * user_list, char *user_name) {
  Event * early_event;
  if ((early_event = malloc(sizeof(Event))) == NULL) {
    perror("malloc");
    exit(1);
  }

  User * usr = find_user(user_list, user_name);
  if (usr == NULL) {
    return -1;
  }

  Subscription * sub = usr->subscriptions;
  if (sub == NULL) {
    return -1;
  }
  
  //Setting the first event to be compared to as the first event in 
  //the first subscriptions's calendar.
  early_event = (sub->calendar)->events;

  //Setting an arbitrary time (the time of the variable's creation) to comapre event times.
  time_t arb_time = time(NULL);

  while (sub != NULL) {

    //Next line is equivalent to "if the currently considered event is earlier than the earliest
    //event found so far". Note that only teh first events in each subscription's calendar are
    //considered, because theya re all sorted chronologically.
    if (difftime(arb_time, ((sub->calendar)->events)->time) > difftime(arb_time, early_event->time)) {
      early_event = (sub->calendar)->events;
    } 

    sub = sub->next;
  }

  printf("%s: %s", early_event->description, asctime(localtime(&(early_event->time))));
  return 0;
}


/* 
 * Print to stdout a time-ordered list of all events in any calendars
 * subscribed to by this user 
 *
 * Do not change the calendar data-structure. 
 * Return -1 if this user doesn't exist.
 *
 * Returns 
 */
int print_all_events(Calendar *cal_list, User * user_list, char *user_name) {
  User * usr_ptr = find_user(user_list, user_name);
  if (usr_ptr == NULL) {
    return -1;
  }

  Event * rec_event;
  if ((rec_event = malloc(sizeof(Event))) == NULL) {
    perror("malloc");
    exit(1);
  }

  rec_event->description = NULL;
  //Because rec_event->description is currently NULL, need to have one
  //call of the function get_next_event out of the while loop.
  get_next_event(rec_event, user_list, user_name);
  while (rec_event->description != NULL) {
    printf("%s: %s", rec_event->description, asctime(localtime(&(rec_event->time))));
    get_next_event(rec_event, user_list, user_name);
  }

  return 0;
}

/*
 * Changes the decription and time of the passed in event to the description
 * and time of the next event (chronologically) in all of the user's subscribed 
 * calendars. If there are no events after the passed in event, the description
 * is set to NULL.
 *
 * Returns:
 * -1 if there is no such user
 * 0 if event->description and event-> time are chanegd to a new event's description and time
 * 1 if there were no more events after the passed in event and event->description was changed to NULL
 */

int get_next_event(Event * prev_ev, User * user_list, char * user_name) {
  User * usr_ptr = find_user(user_list, user_name);
  if (usr_ptr == NULL) {
    return -1;
  }

  Subscription * sub = usr_ptr->subscriptions; 
  Event * ev;

  Event * ret_ev;
  if ((ret_ev = malloc(sizeof(Event))) == NULL) {
    perror("malloc");
    exit(1);
  }
  ret_ev->description = NULL;

  time_t arb_time = time(NULL);

  //Outer while loop goes through all of teh user's subscriptions;
  //inner while loop goes through all of the subscription's calendar's events.
  while (sub != NULL) {

    ev = (sub->calendar)->events;
    while (ev != NULL) {

      //If prev_ev->description is NULL, whatever the earliest event is is the one 
      //to be returned. If it isn't NULL, the earliest event after it is returned.
      if (prev_ev->description == NULL) {

	if (ret_ev->description == NULL) {
	  ret_ev->description = ev->description;
	  ret_ev->time = ev->time;
	} 
	else if (difftime(arb_time, ev->time) > difftime(arb_time, ret_ev->time)) {
	  ret_ev->description = ev->description;
	  ret_ev->time = ev->time;
	}
      } 

      else if (difftime(arb_time, ev->time) < difftime(arb_time, prev_ev->time)) {

	if (ret_ev->description == NULL) {
  	  ret_ev->description = ev->description;
	  ret_ev->time = ev->time;
	} 
	else if (difftime(arb_time, ev->time) > difftime(arb_time, ret_ev->time)) {
	  ret_ev->description = ev->description;
	  ret_ev->time = ev->time;
	}
      }
      ev = ev->next;
    }
    sub = sub->next;
  }

  prev_ev->description = ret_ev->description;
  prev_ev->time = ret_ev->time;

  if (ret_ev->description == NULL) {
    return 1;
  } else {
    return 0;
  }
}
