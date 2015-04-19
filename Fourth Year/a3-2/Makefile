LOGFILE='"gc.log"'
FLAGS = -DLOGFILE=${LOGFILE} -Wall -g 

all : mktrans do_trans do_fstree

do_trans : do_trans.o list.o gc_list.o gc.o
	gcc ${FLAGS} -o $@ $^

mktrans : mktrans.o list.o gc_list.o gc.o
	gcc ${FLAGS} -o $@ $^

do_fstree : do_fstree.o fstree.o gc_fstree.o gc.o
	gcc ${FLAGS} -o $@ $^
 
%.o : %.c 
	gcc ${FLAGS} -c $<

do_trans.o : list.h
mktrans.o : list.h
list.o : list.h gc.o gc.c
fstree.o : fstree.h gc.o gc.c
do_fstree.o :fstree.h

clean : 
	rm *.o mktrans do_trans do_fstree
