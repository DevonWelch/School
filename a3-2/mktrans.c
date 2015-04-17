/*
 * Generate a random series of add, delete, and print operations on a 
 * linked list.
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "list.h"

#define MAX_VAL 10000

/* The probability of generating print and add operations
 * The probability of generating a delete operation is 
 * 1 - (PROB_PRINT + PROB_ADD)
 */
#define PROB_PRINT 0.05
#define PROB_ADD 0.55



int main(int argc, char **argv) {
    long type;
    long value;
    int length = 0;
    List *ll;
    //printf("%d\n", argc);
    FILE * out_file;
    if (argc > 1) {
      out_file = fopen(argv[1], "w");
      if (out_file == NULL) {
	perror("file");
	exit(1);
      }
    }
    int i;
    for(i = 0; i < MAX_VAL; i++) {
      //printf("got here\n");
        double prob = (double)random() / RAND_MAX;
        if(prob < PROB_PRINT) {
	  //printf("got here 1\n");
            type = 3;
	    if (argc > 1) {
	      fprintf(out_file, "%ld\n", type);
	    } else {
	      printf("%ld\n", type);
	    }
        }
        if(prob < PROB_PRINT + PROB_ADD) {
	  //printf("got here 2\n");
            type = 1;
            value = random() % MAX_VAL;
            ll = add_node(ll, value);
            length++;
	    if (argc > 1) {
	      fprintf(out_file, "%ld %ld\n", type, value);
	    } else {
	      printf("%ld %ld\n", type, value);
	    }
        } else {
            type = 2;
            if(length > 0) {
	      //printf("got here 3\n");
                // choose a node that is in the list to delete
                int index = random() % length;
                value = find_nth(ll, index);
                ll = remove_node(ll, value);
                length--;
		if (argc > 1) {
		  fprintf(out_file, "%ld %ld\n", type, value);
		  //printf("hi\n");
		} else {
		  printf("%ld %ld\n", type, value);
		}
            } 
        }
    }
    if (argc > 1) {
      //printf("%s\n", argv[1]);
      //system("pwd");
      //printf("%d\n", fclose(out_file));
      fclose(out_file);
    }
    return 0;
}


