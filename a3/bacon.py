import bacon_functions

filename = open("large_actor_data.txt")
actor_dict = bacon_functions.parse_actor_data(filename)
movie_dict = bacon_functions.invert_actor_dict(actor_dict)

c = 0
empty = [0]

while c >= 0:
    
    actor_name = raw_input(\
        "Please enter an actor (or press return to exit): ")
    actor_name = actor_name.title()
    
    if actor_name == "":
        
        # If an empty string was entred, we need to present the largest bacon
        # number that has been found. Because we collect all the bacon numbers
        # in a list, we just need to sort it and find the maxium number, which
        # is the last number. Then the whole game stopped.
        
        empty.sort()
        maxium = empty[-1]
        leave = "Thank you for playing! " + \
        "The largest Bacon Number you found was " + str(maxium)
        print leave
        print ''
        c = -1
        # -1 stopped the function from continuing.

        
    elif actor_name == "Kevin Bacon":
        
        # When Kevin Bacon is entred, we automatically know the bacon number
        # is 0.
        
        bacon_num = actor_name + ' has a Bacon Number of 0.'
        print bacon_num
        print ''
        c += 1
        # And the game continues.
        
    else:
        
        # If names other than Kevin Bacon are entred, we use find_connection
        # to determine the bacon number and the related actors and movies.
        
        connection = bacon_functions.find_connection(actor_name, 
                                                     actor_dict,movie_dict)           
        number = len(connection)
        empty = empty + [number]
        
        if len(connection) == 0:
            
            # If there is no connection between the actor and kevin bacon,
            # we say the bacon number is infinity.
            
            bacon_num = actor_name + ' has a Bacon Number of ' + 'Infinity.'
            print bacon_num
            
        else:
            
            # If there is connection between the actor and kevin bacon,
            # we show the bacon number.
            
            bacon_num = actor_name + ' has a Bacon Number of ' + \
                str(number) + '.'
            print bacon_num  
            
            
        if len(connection) >= 1:
            
            # Then we need to show the connection between the actor and
            # Kevin Bacon
            
            c = 0
            while c < len(connection):
                
                if c == 0:
                    
                    # In the first sentence, we need to show the actor
                    # name and the movie that is associated with other
                    # actors
                    
                    print actor_name + " was in " + connection[c][0] + \
                          " with " + connection [0][1] + '.'
                    c += 1
                    
                elif connection[c][1] != "Kevin Bacon":
                    
                    # If the actor name is not Kevin Bacon, we need
                    # to continue printing out the association
                    
                    print connection[c-1][1] + " was in " + \
                          connection[c][0] + " with " + \
                          connection[c][1] + '.'
                    c += 1
                    
                elif connection[c][1] == "Kevin Bacon":
                    
                    # If the actor name is Kevin Bacon, we know it is
                    # the last one of the list, so we print the actor
                    # name and the movie name that is associated with
                    # Kevin Bacon.
                    
                    print connection[c-1][1] + " was in " + \
                          connection[c][0] + " with " + "Kevin Bacon."
                    c = len(connection)
                    
        print ''
        # A space line between each round.
        
        c += 1
        # And the game continues to play.
