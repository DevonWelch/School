#include <stdio.h>
#include <assert.h>
#include <unistd.h>
#include <getopt.h>
#include <stdlib.h>
#include <string.h>
#include "pagetable.h"

#define MAXLINE 256

extern char * tracefile;

extern int memsize;

extern pgdir_entry_t init_second_level();

extern pgtbl_entry_t * find_p(addr_t vaddr);

typedef struct {
  //int occurences[PTRS_PER_PGDIR*PTRS_PER_PGTBL];
  int occurences[10000];
  pgtbl_entry_t * addr;
  int cur_pos;
} next_ref;

//next_ref all_ref[PTRS_PER_PGDIR*PTRS_PER_PGTBL];
next_ref all_ref[10000];

/* Page to evict is chosen using the optimal (aka MIN) algorithm. 
 * Returns the page frame number (which is also the index in the coremap)
 * for the page that is to be evicted.
 */
int opt_evict() {
	 int i;
  int frame = 0;
  int prev_ref = (coremap[0].pte->next_ref);
  for (i = 1; i < memsize; i++) {
    if ((coremap[i].pte->next_ref) > prev_ref) {
      prev_ref = coremap[i].pte->next_ref;
      frame = i;
    }
  }
  return frame;
}

/* This function is called on each access to a page to update any information
 * needed by the opt algorithm.
 * Input: The page table entry for the page that is being accessed.
 */
void opt_ref(pgtbl_entry_t *p) {
  int found = 0;
  int i = 0;
  while ((i < 10000) && (found < 1)) {
    if (all_ref[i].addr == p) {
      p->next_ref = all_ref[i].occurences[p->cur_pos];
      found = 1;
    }
    i++;
  }
  p->cur_pos ++;
}

/* Initializes any data structures needed for this
 * replacement algorithm.
 */
void opt_init() {
  FILE * fd = fopen(tracefile, "r");
  char buf[MAXLINE];
  addr_t vaddr = 0;
  char type;
  int i = 0;
  int found = 0;
  int j = 0;

  while(fgets(buf, MAXLINE, fd) != NULL) {
    j = 0;
    if(buf[0] != '=') {
      sscanf(buf, "%c %lx", &type, &vaddr);
	pgtbl_entry_t *temp_addr=NULL;
	temp_addr = find_p(vaddr);
while ((j < 10000) && (found < 1) && (all_ref[j].addr != NULL)) {
	if (temp_addr == all_ref[j].addr) {
	  all_ref[j].occurences[all_ref[j].cur_pos] = i;
	  found = 1;
	  all_ref[j].cur_pos ++;
	} else if (all_ref[j].addr == NULL) {
	  all_ref[j].occurences[0] = 1;
	  all_ref[j].cur_pos = 1;
	  all_ref[j].addr = temp_addr;
	}
	j ++;
      }
      i++;
    } else {
      continue;
    }

  }
  fclose(fd);
}


