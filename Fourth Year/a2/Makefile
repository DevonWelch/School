CFLAGS = -Wall -g

calendar: calendar.o lists.o 
	gcc $(CFLAGS) -o calendar calendar.o lists.o

calendar.o: calendar.c lists.h
	gcc $(CFLAGS) -c calendar.c

lists.o: lists.c lists.h
	gcc $(CFLAGS) -c lists.c

clean: 
	rm calendar *.o
