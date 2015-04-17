/* Read and execute a list of operations on a linked list.
 * Periodically call the garbage collector.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <time.h>
#include <unistd.h>
#include "list.h"
#include "gc.h"

#define MAX_LINE 128
#define ADD_NODE 1
#define DEL_NODE 2
#define PRINT_LIST 3

List *ll = NULL;

void mark_list(void *);

void collect_garbage() {
  mark_and_sweep(ll, mark_list);
}

int main(int argc, char **argv) {
    char line[MAX_LINE];
    char *str;

    if(argc != 2) {
        fprintf(stderr, "Usage: do_trans filename\n");
        exit(1);
    }

    FILE *fp;
    if((fp = fopen(argv[1], "r")) == NULL) {
        perror("fopen");
        exit(1);
    }

    //List *ll = NULL;
    int count = 1;

    struct sigaction garb_collect;
    sigemptyset(&garb_collect.sa_mask);
    garb_collect.sa_flags = 0;
    garb_collect.sa_handler = collect_garbage;
    if(sigaction(SIGUSR1, &garb_collect, NULL) != 0) {
      perror("sigaction");
      exit(1);
    }

    sigset_t sigs;
    sigemptyset(&sigs);
    sigaddset(&sigs, SIGUSR1);
    sigset_t old_sigs;
    

    while(fgets(line, MAX_LINE, fp) != NULL) {

        char *next;
        int value;
        int type = strtol(line, &next, 0);

        switch(type) {
            case ADD_NODE :
                value = strtol(next, NULL, 0);
		if(sigprocmask(SIG_BLOCK, &sigs, &old_sigs) != 0) {
		  perror("sigprocmask");
		  exit(1);
		}
                ll = add_node(ll, value);
		if(sigprocmask(SIG_SETMASK, &old_sigs, NULL) != 0) {
		  perror("sigprocmask");
		  exit(1);
		}
                break;
            case DEL_NODE :
                value = strtol(next, NULL, 0);
                ll = remove_node(ll, value);
                break;
            case PRINT_LIST :
                str = tostring(ll);
                //printf("List is %s\n", str);
                break;
            default :
                fprintf(stderr, "Error: bad transaction type\n");

        }
    
        
        if(count % 10 == 0) {
	  usleep(20000);
	  //mark_and_sweep(ll, mark_list);
            // You might want to add something here to
            // make your program pause long enough to see what it
            // is doing. In the commented out code, we wait for 
            // any user input before continuing.
 
            // char check[MAX_LINE];
            // fgets(check, MAX_LINE, stdin);
        }       
        count++;

    }
    return 0;
}
