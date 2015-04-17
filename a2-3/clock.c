#include <stdio.h>
#include <assert.h>
#include <unistd.h>
#include <getopt.h>
#include <stdlib.h>
#include <time.h>
#include "pagetable.h"


extern int memsize;

extern int debug;

extern struct frame *coremap;

/* Page to evict is chosen using the clock algorithm.
 * Returns the page frame number (which is also the index in the coremap)
 * for the page that is to be evicted.
 */

int clock_evict() {
  int i;
  int frame = 0;
  time_t temp_time = time(NULL);
  double prev_time = 0;
  for (i= 0; i < memsize; i++) {
    if (difftime(temp_time, coremap[i].time_in) > prev_time) {
      if (coremap[i].pte->frame & PG_REF) {
	coremap[i].pte->frame &= ~PG_REF;
	coremap[i].time_in = time(NULL);
      }
      else {
	prev_time = difftime(temp_time, coremap[i].time_in);
	frame = i;
      }
    }
  }
  return frame;
}

/* This function is called on each access to a page to update any information
 * needed by the clock algorithm.
 * Input: The page table entry for the page that is being accessed.
 */
void clock_ref(pgtbl_entry_t *p) {

  if (coremap[p->frame >> PAGE_SHIFT].time_in == 0) {
    coremap[p->frame >> PAGE_SHIFT].time_in = time(NULL);
  }

	return;
}

/* Initialize any data structures needed for this replacement
 * algorithm. 
 */
void clock_init() {
}
