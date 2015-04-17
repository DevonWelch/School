#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <semaphore.h>

#define PAGE 4096

typedef struct mem_list Mem_list;

struct mem_list{
  unsigned int size;
  struct mem_list *next;
};

/*increases the pointer by the specified size.
  when passed "size + sizeof(Mem_list)" for 
  size, that means that the returned pointer
  will point to the beginning of what will
  be a smaller free block
*/
Mem_list * inc_mem(Mem_list * mem, int size) {
  long x = (long) mem;
  x += size;
  return (Mem_list *) x;
}

//abs_head and abs_end are used to keep track of 
//the range of memory addresses available. 
int * abs_head;
int * abs_end;
Mem_list * mem_head;
sem_t S;

/* mymalloc_init: initialize any data structures that your malloc needs in
   order to keep track of allocated and free blocks of 
   memory.  Get an initial chunk of memory for the heap from
   the OS using sbrk() and mark it as free so that it can  be 
   used in future calls to mymalloc()
*/

int mymalloc_init() {

  abs_head = sbrk(PAGE);
  if (abs_head < 0) {
    perror("sbrk");
    return -1;
  }
  abs_end = (int *) inc_mem((Mem_list *) abs_head, PAGE);

  mem_head = (Mem_list *) abs_head;
  mem_head->size = PAGE - sizeof(Mem_list);
  mem_head-> next = 0;
  sem_init(&S, 0, 1);
  return 0;

}


/* mymalloc: allocates memory on the heap of the requested size. The block
   of memory returned should always be padded so that it begins
   and ends on a word boundary.
   unsigned int size: the number of bytes to allocate.
   retval: a pointer to the block of memory allocated or NULL if the 
   memory could not be allocated. 
   (NOTE: the system also sets errno, but we are not the system, 
   so you are not required to do so.)
*/
void *mymalloc(unsigned int size) {

  sem_wait(&S);

  //ensuring the size to be allocated will be a multiple of 8,
  //meaning the address will too
  int rem = size % 8;
  if (rem != 0) {
    size += rem;
  }

  Mem_list * best_place = mem_head;
  Mem_list * pnt_to_best = NULL;
  Mem_list * free_list = mem_head;

  //looping thorugh all free blocks
  while (0 != free_list->next && NULL != free_list->next && free_list != 0) {

    //if the specified free block is exactly big enough for teh given size or it is 
    //big enough for the given size with enough extra room for a new Mem_list, AND 
    //it is smaller than the previously chosen free block
    if ((((free_list->next)->size == size) || ((free_list->next)->size > (size + sizeof(Mem_list)))) 
	&& (((free_list->next)->size) <= best_place->size)) {

      best_place = free_list->next;
      //keeping the pointer of the Mem_list that is
      //prior to the found location in the list,
      //the purpose of which is to be able to
      //change the next pointer of pnt_to_best
      pnt_to_best = free_list;

    }

    free_list = free_list->next;

  }

  if (best_place == mem_head) {

    //if nowhere has been found to be large enough to allocate memory
    if ((size + (sizeof(Mem_list))) >= mem_head->size) {

      best_place = (Mem_list *) sbrk(PAGE);
      if (best_place < 0) {
	perror("sbrk");
	return NULL;
      }
      abs_end = (int *) inc_mem(best_place, PAGE);

      int i = 1;
      //increase the available space until there is enough
      while (i*PAGE <= (2*(sizeof(Mem_list)) + size)) {
	i ++;
	abs_end = (int *) inc_mem(sbrk(PAGE), PAGE);
	if (abs_end < 0) {
	  perror("sbrk");
	  return NULL;
	}
      }

      Mem_list * new_place = inc_mem(best_place, size + sizeof(Mem_list));
      new_place->next = mem_head;
      new_place->size = i*PAGE - size - 2*(sizeof(Mem_list));
      mem_head = new_place;
      best_place->size = size;

    } 

    //if the first element of the free list was 
    //determined to be the best location
    else {

      Mem_list * prev_head_next = mem_head->next;
      mem_head = inc_mem(mem_head, size + sizeof(Mem_list));
      rem = ((long) mem_head) % 8;
      if (rem != 8) {
	mem_head = inc_mem(mem_head, rem);
      }
      mem_head->size = best_place->size - size - sizeof(Mem_list);
      mem_head->next = prev_head_next;
      best_place->size = size;

    }

  } 

  //if a suitable location large enough to put a new header in was found
  else if (best_place->size > (size + sizeof(Mem_list))) {

    Mem_list * new_place = inc_mem(best_place, size + sizeof(Mem_list));
    new_place->size = best_place->size - size - sizeof(Mem_list);
    new_place->next = best_place->next;
    best_place->size = size;
    pnt_to_best->next = new_place;

  } 

  //if a suitable locationw as found exactly as large as size
  else {

    pnt_to_best->next = best_place->next;

  }

  //returning a pointer to the start of the free space, 
  //rather than the header
  best_place = inc_mem(best_place, sizeof(Mem_list));
  sem_post(&S);
  return best_place;

}


/* myfree: unallocates memory that has been allocated with mymalloc.
   void *ptr: pointer to the first byte of a block of memory allocated by 
   mymalloc.
   retval: 0 if the memory was successfully freed and 1 otherwise.
   (NOTE: the system version of free returns no error.)
*/
unsigned int myfree(void *ptr) {

  if ((int *) ptr < abs_head || (int *) ptr > abs_end) {
    fprintf(stderr, "Given pointer (%p) is outside of the program's scope.", ptr);
    return 1;
  }

  sem_wait(&S);

  Mem_list * temp_head = mem_head;

  //prev_free is a block that is ends where the passed in ptr begins,
  //whereas next_free is a block that begins where ptr ends
  Mem_list * prev_free = NULL;
  Mem_list * next_free = NULL;

  //pnt_to_nxt is the Mem_list prior to next_free
  Mem_list * pnt_to_nxt = NULL;
  Mem_list * prev_pnt = NULL;

  //gets the address of the header of ptr
  long x = (long) ptr;
  Mem_list * temp_ptr = (Mem_list *) (x - sizeof(Mem_list));

  while ((temp_head != 0) && (temp_head != NULL)) {

    //if a preceding free block is found
    if (temp_head + temp_head->size == temp_ptr) {

      prev_free = temp_head;

    } 

    //if a subsequent free block is found
    else if (temp_head == ptr + temp_ptr->size) {

      next_free = temp_head;
      pnt_to_nxt = prev_pnt;  

    } 

    //if the passed in ptr is in the free list
    else if (temp_head == temp_ptr) {

      sem_post(&S);
      fprintf(stderr, "Given pointer (%p) is already freed.", ptr);
      return 1;

    }

    prev_pnt = temp_head;
    temp_head = (temp_head->next);

  }
  
  //if a following free block was found and not a preceding one
  if ((next_free != NULL) && (prev_free == NULL)) {

    temp_ptr->size = temp_ptr->size + next_free->size + sizeof(Mem_list);
    temp_ptr->next = next_free->next;

    //if pnt_to_nxt is NULL, next_free is the head of the free list,
    //and so the newly freed block is palced at the head of the list
    if (pnt_to_nxt != NULL) {

      pnt_to_nxt->next = temp_ptr;

    } 

    else {

      mem_head = temp_ptr;

    }

  } 

  //if a preceding free block was found and not a following one
  else if ((next_free == NULL) && (prev_free != NULL)) {

    prev_free->size = prev_free->size + temp_ptr->size + sizeof(Mem_list);

  } 

  //if both a preceding and a following block were found
  else if ((next_free != NULL) && (prev_free != NULL)) {

    prev_free->size = prev_free->size + temp_ptr->size + next_free->size + 2*(sizeof(Mem_list));

    //if the preceding block immediately follows the next block in the free list;
    //in this case, the block that pointed to next_free will now point to prev_free
    if ((next_free->next) == prev_free) {

      //if pnt_to_nxt is NULL, next_free is the head of the free list,
      //and so the newly freed block is placed at the head of the list
      if (pnt_to_nxt != NULL) {

	pnt_to_nxt->next = prev_free;

      } 

      else {

	mem_head = prev_free;

      }

    } 

    //if the next block immediately follows the previous block in the free list;
    //in this case, prev_free will be made to point to where next_free sued to point to
    else if (prev_free->next == next_free) {

      prev_free->next = next_free->next;

    } 

    //if next_free and prev_free are not neighbours in teh free list.
    //in this case, the block that pointed to next_free will be made to 
    //point to where next_free pointed to
    else {

      //if pnt_to_nxt is NULL, next_free is the head of the free list,
      //and so the newly freed block is palced at the head of the list
      if (pnt_to_nxt != NULL) {

	pnt_to_nxt->next = next_free->next;

      } 

      else {

	mem_head = next_free->next;

      }

    }

  } 

  //if temp_ptr had no neighbours. it is set as the head of the list. 
  else {

    temp_ptr->next = mem_head;
    mem_head = temp_ptr;

  }

  sem_post(&S);
  return 0;

}

