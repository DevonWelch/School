#include <stdio.h>
#include <stdlib.h>
#include "gc.h"
struct mem_chunk * glbl_mem_lst;

void *gc_malloc(int nbytes) {
  struct mem_chunk * new_mem_chunk_ptr = malloc(sizeof(struct mem_chunk));
  if (new_mem_chunk_ptr == NULL) {
    perror("malloc");
    exit(1);
  }
  new_mem_chunk_ptr->in_use = USED;
  if((new_mem_chunk_ptr->address = malloc(nbytes)) == NULL) {
    perror("malloc");
    exit(1);
  }
  new_mem_chunk_ptr->next = glbl_mem_lst;
  glbl_mem_lst = new_mem_chunk_ptr;
  return new_mem_chunk_ptr->address;
}

void mark_and_sweep(void *obj, void (*mark_obj)(void *)) {
  mark_obj(obj);
}
