#include <stdio.h>
#include <stdlib.h>
#include "gc.h"
#include "fstree.h"

struct mem_chunk mem_lst = {0, NULL, NULL};
struct mem_chunk * glbl_mem_lst = &mem_lst;

int mark_tree_helper(Fstree * tree);

void mark_fstree(Fstree * tree) {
  printf("%d\n", glbl_mem_lst->address);
  printf("%d\n", glbl_mem_lst->next->address);
  get_mem_len();
  if (glbl_mem_lst == NULL) {
    return;
  }
  //reset flags
  struct mem_chunk * mem_test = glbl_mem_lst;
  while (mem_test->next != NULL) {
    mem_test->in_use = NOT_USED;
    mem_test = mem_test->next;
  }
  //printf("reset flags\n");
  //mark
  mark_tree_helper(tree);
  /*Fstree * test_tree = tree;
  while (test_tree != NULL) {
    mark_one(test_tree);
    test_tree = test_tree->next;
    }*/
  //sweep
  mem_test = glbl_mem_lst;
  //get to first in-use entry in memory list.
  //
  while (mem_test->in_use == 0) {
    free(mem_test->address);
    glbl_mem_lst = glbl_mem_lst->next;
    mem_test = mem_test->next;
  }
  while (mem_test->next != NULL) {
    if (mem_test->next->in_use == 1) {
      mem_test = mem_test->next;
    } else {
      free(mem_test->next->address);
      mem_test->next = mem_test->next->next;
    }
  }
  get_mem_len();
}

int mark_tree_helper(Fstree * tree) {
  printf("something\n");
  printf("%d\n", tree);
  printf("%s\n", tree->name);
  if (mark_one(tree) == 1) {
    return 0;
  } else {
    mark_one(tree->name);
    Link * temp_links = tree->links;
    while (temp_links != NULL) {
      mark_one(temp_links);
      mark_tree_helper(temp_links->fptr);
      printf("%d\n", temp_links->fptr);
      printf("%s\n", temp_links->fptr->name);
      temp_links = temp_links->next;
    }
  }
  return 0;
}

int mark_one(void * tree) {
  printf("something 3\n");
  struct mem_chunk * mem_test = glbl_mem_lst;
  if (mem_test == NULL) {
    printf("mem_test is NULL\n");
  }
  printf("soemthing 4\n");
  while (mem_test->next != NULL) {
    if (mem_test->address == tree) {
      if (mem_test->in_use == USED) {
	printf("USED\n");
	return 1;
      } else {
	printf("NOT USED\n");
	mem_test->in_use = USED;
	printf("something 2\n");
	return 0;
      }
    }
    mem_test = mem_test->next;
  }
  printf("soemthing's wrong\n");
  printf("%d\n", tree);
  printf("%d\n", glbl_mem_lst->address);
  return -1;
}

void get_mem_len() {
  int count = 0;
  struct mem_chunk * mem_thing = glbl_mem_lst;
  while (mem_thing != NULL) {
    count ++;
    printf("%d\n", mem_thing->address);
    mem_thing = mem_thing->next;
  }
  printf("%d\n", count);
}
