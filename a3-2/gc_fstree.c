#include <stdio.h>
#include <stdlib.h>
#include "gc.h"
#include "fstree.h"

struct mem_chunk mem_lst = {1, NULL, NULL};
struct mem_chunk * glbl_mem_lst = &mem_lst;

int mark_tree_helper(Fstree * tree);

int rev_check_all_mem(Fstree * tree);

int check_all_mem(Fstree * tree);

int get_mem_len();

int count_tree(Fstree *f);

void mark_fstree(Fstree * tree) {

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
  mark_tree_helper(tree);
  //done marking

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
  //are in the memory list after freeing, freed correctly is 1 if all objects 
  //in the tree that used gc_malloc are in the memory list, and 0 otherwise,
  //have all memory is 1 if all elements in the meory list are in the tree
  fprintf(out_file, "before: %d, freed: %d, left: %d, freed correctly: %d, have all memory: %d\n", 
	  //the following line does not work if the tree has a hard link.
	  //use the following, commented out line.
	  bef_rel, bef_rel-aft_rel, aft_rel, check_all_mem(tree), rev_check_all_mem(tree));
  	  //bef_rel, bef_rel-aft_rel, aft_rel, 1, 1);
  fclose(out_file);
  //done updating LOGFILE
}

/* 
/  Handles the marking part of flag, mark, and sweep. 
/  Works on trees with cycles. 
*/
int mark_tree_helper(Fstree * tree) {

  //if the address of the tree has already been marked,
  //the function ends so that it does recurse infinitely.
  if (mark_one(tree) == 1) {
    return 0;
  } 

  else {

    mark_one(tree->name);
    Link * temp_links = tree->links;

    while (temp_links != NULL) {
      mark_one(temp_links);
      mark_tree_helper(temp_links->fptr);
      temp_links = temp_links->next;
    }

  }
  return 0;
}

/*
/ Returns 1 if address has already been marked in_use,
/ 0 if it has not been marked, and -1 if it is not
/ in the memory list.
*/

int mark_one(void * tree) {
  struct mem_chunk * mem_test = glbl_mem_lst;
  while (mem_test->next != NULL) {

    if (mem_test->address == tree) {

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

int check_help(void * tree) {
  struct mem_chunk * mem_thing = glbl_mem_lst;
  while(mem_thing != NULL) {

    if (mem_thing->address == tree) {
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
/ the tree.
/
/ Returns 0 if the address is not in 
/ the tree, 1 if it is.
*/

int rev_help(Fstree * tree, struct mem_chunk * mem_thing) {
  Fstree * temp_tree = tree;

  if (temp_tree == mem_thing->address || temp_tree->name == mem_thing->address) {
    return 1;
  } 
  
  else {
    Link * temp_links = tree->links;
    while (temp_links != NULL) {

      if (temp_links == mem_thing->address) {
	return 1;
      }
      
      else {
	if (rev_help(temp_links->fptr, mem_thing) == 1) {
	  return 1;
	}
	temp_links = temp_links->next;
      }
    }
  }
  return 0;
}

/*
/ Checks if all addresses in the tree are in
/ in the memory list. 
/
/ Returns 0 if there is an address not in the memory list,
/ 1 if they are all there.
*/

int check_all_mem(Fstree * tree) {
  Fstree * temp_tree = tree;

  if(check_help(temp_tree) == 0 || check_help(tree->name) == 0) {
    return 0;
  }

  Link * temp_links = tree->links;
  while (temp_links != NULL) {

    if (check_help(temp_links) == 0) {
      return 0;
    } 

    else {

      if (check_all_mem(temp_links->fptr) == 0) {
	return 0;
      }

      temp_links = temp_links->next;
    }
  }
  return 1;
}

/*
/ Checks if all addresses in the memory list are
/ in the tree passed in. 
/
/ Returns 0 if there is an address not in the tree,
/ 1 if they are all there.
*/

int rev_check_all_mem(Fstree * tree) {
  Fstree * temp_tree = tree;
  struct mem_chunk * mem_thing = glbl_mem_lst;

  while(mem_thing->next != NULL) {

    if (rev_help(temp_tree, mem_thing) == 0) {
      return 0;
    }

    else {
      mem_thing = mem_thing->next;
    }
  }
  return 1;
}
