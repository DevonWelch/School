PORT=51748
CFLAGS = -DPORT=\$(PORT) -Wall -g

all : calserver

calserver : calendar.o lists.o
	gcc ${CFLAGS} -o $@ $^

%.o : %.c
	gcc ${CFLAGS} -c $<

lists.o : lists.h

calendar.o : lists.o

clean : 
	rm *.o calserver