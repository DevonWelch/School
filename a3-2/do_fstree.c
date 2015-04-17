#include <stdio.h>
#include <signal.h>
#include <time.h>
#include <stdlib.h>
#include <unistd.h>
#include "fstree.h"
#include "gc.h"

extern Fstree *root;

void mark_fstree(void *);

/*
/ Function to be called when SIGUSR1 is recieved.
*/
void collect_garbage() {
  mark_and_sweep(root, mark_fstree);
}

int main() {

  //extern Fstree *root;
  root = create_node("root");
    
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

  //do_transactions("fs_trans1");
  int count = 1;
  while (count < 100) {

    usleep(100000);

    if(sigprocmask(SIG_BLOCK, &sigs, &old_sigs) != 0) {
      perror("sigprocmask");
      exit(1);
    }
    do_transactions("fs_trans1");
    if(sigprocmask(SIG_SETMASK, &old_sigs, NULL) != 0) {
      perror("sigprocmask");
      exit(1);
    }
    //printf("%s\n", root->name);
    //printf("%d\n", root);


    /* try uncommenting various bits to use other test files */

    //do_transactions("fs_trans2");

    if(sigprocmask(SIG_BLOCK, &sigs, &old_sigs) != 0) {
      perror("sigprocmask");
      exit(1);
    }
    do_transactions("fs_trans_loop");
    if(sigprocmask(SIG_SETMASK, &old_sigs, NULL) != 0) {
      perror("sigprocmask");
      exit(1);
    }
    // don't call print_tree once you have a loop. It isn't sophisticated 
    // enough to handle the loop
    //print_tree(root, 0);

    //Or you can put the calls directly in here but be careful, you
    //can't use string literals for the paths or you will get Segmentation errors.

    if(sigprocmask(SIG_BLOCK, &sigs, &old_sigs) != 0) {
      perror("sigprocmask");
      exit(1);
    }
    add_node("","one");  // add_node (path, name)
    if(sigprocmask(SIG_SETMASK, &old_sigs, NULL) != 0) {
      perror("sigprocmask");
      exit(1);
    }
    //print_tree(root, 0);
    if(sigprocmask(SIG_BLOCK, &sigs, &old_sigs) != 0) {
      perror("sigprocmask");
      exit(1);
    }
    add_node("one","oneone");  // add_node (path, name)
    if(sigprocmask(SIG_SETMASK, &old_sigs, NULL) != 0) {
      perror("sigprocmask");
      exit(1);
    }
    //print_tree(root, 0);
    //printf("************\n");

    /*char dest_path[20] = "one/oneone";
      char src_path[20] = "";
      char name[10] = "one";*/

    // this makes a link as a child of  one/oneone back to /one
    //add_hard_link(dest_path, src_path, name);
    // DON"T call print_tree now since it doesn't handle loops and 
    //  will print infinitely
    //print_tree(root, 0);



    // once you've implemented your garbage collector on fstree, you can
    // call it from here at various points to clean up the garbage
    //if ((count % 10) == 0) {
    //printf("got here\n");
    //print_tree(root, 0);
    //printf("%s\n", root->name);
    //printf("%d\n", root);
    //mark_and_sweep(root, mark_fstree);
    //}
    count ++;
    //printf("one iteration done\n");
  }

  return 0;
}
