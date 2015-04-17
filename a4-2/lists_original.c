#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "lists.h"

/*
 * Return a pointer to the struct calendar with name cal_name
 * or NULL if no calendar with this name exists in the cal_list
 */
Calendar *find_calendar(Calendar *cal_list, char *cal_name) {
    Calendar *current = cal_list;
    while (current != NULL && (strcmp(current->name, cal_name) != 0)) {
        current = current->next;
    }
    return current;
}

/* 
 * Return a pointer to the user with name username or NULL
 *   if no such user exists in user_list 
 */
User *find_user(User *user_list, char *username) {
    User *current = user_list;
    while (current != NULL && (strcmp(current->name, username) != 0)) {
        current = current->next;
    }
    return current;
}

/* 
 * If a calendar with name cal_name does not exist, create a new
 * calendar by this name and insert it at the front of the calendar list.
 * Return values:
 *    0 if successful
 *   -1 if a calendar by cal_name already exists
 */
int add_calendar(Calendar **cal_list_ptr, char *cal_name) {
   if (find_calendar(*cal_list_ptr, cal_name) != NULL) {
        // calendar by this name already exists
        return -1;
    } else {
        //malloc space for new Calendar
        Calendar *newcal;
        if ((newcal = malloc(sizeof(Calendar))) == NULL) {
           perror("Error allocating space for new Calendar");
           exit(1);
        }
        // set the fields of the new calendar node
        // first allocate space for the name
        int needed_space = strlen(cal_name) + 1;
        if (( newcal->name = malloc(needed_space)) == NULL) {
           perror("Error allocating space for new Calendar name");
           exit(1);
        }
        strncpy(newcal->name, cal_name, needed_space);
        newcal->events = NULL;

        // insert new calendar into head of list
        newcal->next = *cal_list_ptr;
        *cal_list_ptr = newcal;
        return 0;
    }
}

/* 
 * Print to stdout a list of all current calendar names (one per line)
 */
void list_calendars(Calendar *cal_list) {
    Calendar *current = cal_list;
    while (current != NULL) {
        printf("%s\n",current->name);
        current = current->next;
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
   if (find_user(*user_list_ptr, username) != NULL) {
        // user by this name already exists
        return -1;
    } else {
        //malloc space for new User
        User *newuser;
        if ((newuser = malloc(sizeof(User))) == NULL) {
           perror("Error allocating space for new User");
           exit(1);
        }
        // set the fields of the new user node
        // first allocate space for the name
        int needed_space = strlen(username) + 1;
        if (( newuser->name = malloc(needed_space)) == NULL) {
           perror("Error allocating space for new User name");
           exit(1);
        }
        strncpy(newuser->name, username, needed_space);
        newuser->subscriptions = NULL;
        newuser->next = NULL;

        // insert new user into tail of list
        User *current = *user_list_ptr;
        if (current == NULL) {
            // this is the first user, put it at the front
            *user_list_ptr = newuser;
        } else {
            while (current->next != NULL) {
                current = current->next;
            }
            current->next = newuser;
         }
        return 0;
    }
}

/* 
 * Print to stdout a list of usernames one per line 
 */
void list_users(User *user_list) {
    User *current = user_list;
    while (current != NULL) {
        printf("%s\n",current->name);
        current = current->next;
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
    User *this_user;
    Calendar *this_cal;
    if ((this_user = find_user(user_list, username)) == NULL) {
        return -1;
    }
    if ((this_cal = find_calendar(cal_list, cal_name)) == NULL) {
        return -2;
    }

    /* Check if this user is already subscribed to this calendar as we
     * walk down the list of subscriptions.
     * Newest subscriptions are added at the tail of the list.
     * Don't create the struct until we know that we are going to need it.
     */
    Subscription *current = this_user->subscriptions;
    while ((current != NULL) && (current->calendar != this_cal)) {
        // we aren't at the end and haven't found this calendar yet
        current = current->next;
    }
    if (current != NULL) {
        // we found the calendar already in the subscription list
        return -3;
    }
    // if we get this far we do need to create a subscription struct
    Subscription *newsub;
    if ((newsub = malloc(sizeof(Subscription))) == NULL) {
        perror("Error allocating space for new Subscription");
        exit(1);
    }
    // we've made the subscription object but need to set it to point 
    //   to the calendar we are subscribing to 
    newsub->calendar = this_cal;
    newsub->next = NULL;
    // put this new subscription object into the list of subscriptions 
    // for this user 
    if (this_user->subscriptions == NULL) {
        // this is the first subscription it goes at the head
        this_user->subscriptions = newsub;
    } else {
        // we walk down until we find the end
        current = this_user->subscriptions;
        while (current->next != NULL) {
            current = current->next;
        }
        current->next = newsub;
    }
    return 0;
}

/* 
 * Add an event with this name and date to the calender with name cal_name 
 *  Return:
 *   0 for success
 *  -1 for calendar does not exist by this name
 */
int add_event(Calendar *cal_list, char *cal_name, char *event_name, time_t time) {

    // Find the correct calendar so we can find the correct event_list.
    //   Do this first, so if it fails we haven't created a memory leak 
    //   with the new_event. 
    Calendar * this_cal;
    if ((this_cal = find_calendar(cal_list, cal_name)) == NULL) {
        return -1;
    }

    // create the Event that we will insert
    Event *new_event;
    if ((new_event = malloc(sizeof(Event))) == NULL) {
        perror("Error allocating space for new Event");
        exit(1);
    }
    int needed_space = strlen(event_name) + 1;
    if ((new_event->description = malloc(needed_space)) == NULL) {
        perror("Error allocation space for event description");
        exit(1);
    }
    strncpy(new_event->description, event_name, needed_space);
    new_event->time = time; // calendar time

    // Find correct place to insert this event (sorted by time.) 
    Event *cur = this_cal->events;
    if (cur == NULL || cur->time > new_event->time) { 
        // this is the first event for this calendar 
        //   or it goes before the first event in time
        new_event->next = this_cal->events; // don't drop the list of events 
        this_cal->events = new_event;
    } else {
        Event * prev = cur;
        cur = cur->next;
        while ((cur != NULL) && (cur->time < new_event->time)) {
            // we are not at the end nor have we found the correct spot
            prev = cur;
            cur = cur->next;
        }
        // insert after previous and before cur (which may be null)
        new_event->next = cur;
        prev->next = new_event;
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
    // find the correct calendar so we can find the correct event_list 
    Calendar * this_cal;
    if ((this_cal = find_calendar(cal_list, cal_name)) == NULL) {
        return(-1);
    }
    Event *cur = this_cal->events;
    printf("Events for calendar %s:\n",this_cal->name);
    while (cur != NULL) {
        printf(" %s: ",cur->description);
        printf("%s",ctime(&(cur->time)));
        cur = cur->next;
    }
    return 0;
}

