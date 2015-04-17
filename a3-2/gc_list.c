#include <stdio.h>
#include <stdlib.h>
#include "gc.h"
#include "list.h"

struct mem_chunk mem_lst = {1, NULL, NULL};
struct mem_chunk * glbl_mem_lst = &mem_lst;

int rev_check_all_mem(List * lst);

int check_all_mem(List * lst);

int get_mem_len();

void mark_list(List * lst) {
 
  //amount of elements in the memory list; saved for
  //updating the LOGFILE
  int bef_rel = get_mem_len();

  //reset flags
  struct mem_chunk * mem_test = glbl_mem_lst;
  //does not set the last element of the memory list
  //to NOT_USED, because that way it will never be removed.
  while (mem_test->next != NULL) {
    mem_test->in_use = NOT_USED;
    mem_test = mem_test->next;
  }
  //done resetting flags

  //mark
  List * test_lst = lst;
  while (test_lst != NULL) {
    mark_one(test_lst);
    test_lst = test_lst->next;
  }
  //done amrking

  //sweep
  mem_test = glbl_mem_lst;

  //get to first in-use entry in memory list.
  while (mem_test->in_use == 0) {
    free(mem_test->address);
    glbl_mem_lst = glbl_mem_lst->next;
    mem_test = mem_test->next;
  }

  //once first element of memory list is still in use,
  //goes through the rest of the list, checking if 
  //the next element is still in use; if it is, 
  //go to next element, otherwise, free the next element
  //and set next element to next's next; the final element,
  //an empty element, is always marked as in-use
  while (mem_test->next != NULL) {

    if (mem_test->next->in_use == 1) {
      mem_test = mem_test->next;
    } 

    else {
      free(mem_test->next->address);
      mem_test->next = mem_test->next->next;
    }

  }
  //done sweeping

  //updating LOGFILE
  //aft_rel is the amount of elements in the memory list after the sweep
  int aft_rel = get_mem_len();
  FILE * out_file;
  out_file = fopen(LOGFILE, "a");
  if (out_file == NULL) {
    perror("file");
    exit(1);
  }
  //before is how many elements were in the memory list before this round of freeing,
  //freed is how many memory elements were freed, left is how many elements
  //are in the memory list after freeing, actual is the amount of elements in the list, 
  //counted using the given length function; freed correctly is 1 if all objects 
  //in the tree that used gc_malloc are in the memory list, and 0 otherwise,
  //have all memory is 1 if all elements in the meory list are in the tree
  fprintf(out_file, "before: %d, freed: %d, left: %d, actual: %d, freed correctly: %d, have all memory: %d \n", 
	  bef_rel, bef_rel-aft_rel, aft_rel, length(lst), check_all_mem(lst), rev_check_all_mem(lst));
  fclose(out_file);
  //done updating LOGFILE
}

/*
/ Returns 1 if address has already been marked in_use,
/ 0 if it has not been marked, and -1 if it is not
/ in the memory list.
*/

int mark_one(void * lst) {
  struct mem_chunk * mem_test = glbl_mem_lst;
  while (mem_test->next != NULL) {

    if (mem_test->address == lst) {

      if (mem_test->in_use == USED) {
	return 1;
      } 

      else {
	mem_test->in_use = USED;
	return 0;
      }
    }

    mem_test = mem_test->next;

  }
  return -1;
}

/* 
/ Returns the amount of elements in the memory list,
/ not including the last one.
*/

int get_mem_len() {
  int count = 0;
  struct mem_chunk * mem_thing = glbl_mem_lst;
  while (mem_thing != NULL) {
    count ++;
    mem_thing = mem_thing->next;
  }
  return count - 1;
}

/*
/ Helper function for check_all_mem.
/ Checks if the address passed in
/ is in the memory list.
/
/ Returns 0 if the address is not in the
/ memory list, 1 if it is.
*/ 

int check_help(List * lst) {
  struct mem_chunk * mem_thing = glbl_mem_lst;
  while(mem_thing != NULL) {

    if (mem_thing->address == lst) {
      return 1;
    } 

    else {
      mem_thing = mem_thing->next;
    }

  }
  return 0;
}

/*
/ Helper function for rev_check_all_mem.
/ Checks if the address of mem_thing is in 
/ the list.
/
/ Returns 0 if the address is not in 
/ the list, 1 if it is.
*/

int rev_help(List * lst, struct mem_chunk * mem_thing) {
  List * temp_lst = lst;
  while(temp_lst != NULL) {

    if (mem_thing->address == temp_lst) {
      return 1;
    } 

    else {
      temp_lst = temp_lst->next;
    }

  }
  return 0;
}

/*
/ Checks if all addresses in the list are in
/ in the memory list. 
/
/ Returns 0 if there is an address not in the memory list,
/ 1 if they are all there.
*/

int check_all_mem(List * lst) {
  List * temp_lst = lst;
  while (temp_lst != NULL) {

    if (check_help(temp_lst) == 0) {
      return 0;
    } 

    else {
      temp_lst = temp_lst->next;
    }

  }
  return 1;
}

/*
/ Checks if all addresses in the memory list are
/ in the list passed in. 
/
/ Returns 0 if there is an address not in the list,
/ 1 if they are all there.
*/

int rev_check_all_mem(List * lst) {
  List * temp_lst = lst;
  struct mem_chunk * mem_thing = glbl_mem_lst;

  while(mem_thing->next != NULL) {

    if (rev_help(temp_lst, mem_thing) == 0) {
      return 0;
    } 

    else {
      mem_thing = mem_thing->next;
    }

  }
  return 1;
}
