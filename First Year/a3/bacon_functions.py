def get_movie_name(movie):
    '''Return a string 'movie_name' from string 'movie', where the string 
    'movie' starts with the name of the movie, followed by the year it was made,
    and potentially followed by other unwanted text. This function is to be 
    utilized in parse_actor_data'''
    
    movie_name = ''
    condition = 0
    for element in movie:
        if condition == 0:
            if element.startswith('('):
                if element[1:5].isdigit():
                # The first if statement is to check if the next word is in 
                # brackets, and the second is to check if it contains only 
                # numbers. The assumption is made that if the contents of the 
                # brackets are 4 characters long (so as to be in year format)
                # and all digits, then it will be the year in which the movie 
                # was made, and not a part of the movie name. Any other piece 
                # of information in brackets will be excluded.
                    movie_name += element
                    condition += 1
            else: 
                movie_name += element + ' '  
    return movie_name
  

def parse_actor_data(actor_data):
    '''Return the actor information in the open reader actor_data as a 
    dictionary. actor_data contains movie and actor information in IMDB's 
    format. The returned dictionary contains the names of actors (string) as 
    keys and lists of movies (string) the actor has been in as values.'''
    
    actor_dict = {}
    current_actor = ''
    line = actor_data.readline()
    while not line.startswith('----\t'):
    # The purpose of this while loop is to get to the part of the text file that
    # contains the actors and the movies.
        line = actor_data.readline()
    line = actor_data.readline()
    while line != '' and not line.startswith('-----') :
    # The purpose of this while loop is to get all the way through the part of
    # the text file dealing with the actors and teh movies, and to stop after
    # that. 
        if line[0].isalpha():
        # The purpose of this outer if/else block is to determine if the line
        # has the name of an actor at the beginning.
            if ((line.split())[0]).endswith(',') or \
               ((line.split())[1]).endswith(','):
                get_name = line.split(',')
                get_name[1] = get_name[1].split('\t')
                # The purpose of this split is to ensure that if the actor's 
                # name is three words or more they will be included in 'name'.
                get_name[1][0] = get_name[1][0].split()
                first_part_of_name = ''
                for element in get_name[1][0]:
                    if not element.startswith('('):
                    # This if is to ensure that roman numerals after the actor's
                    # name will not be included. 
                        first_part_of_name += ' ' + element    
                name = first_part_of_name + ' ' + get_name[0]
                name = name.strip()
                name = name.title()
                movie = line[(len(name) + 1):]
            else: 
                name = (line.split())[0]
                name = name.title()
                movie = line[(len(name)):]
            # The purpose of this inner if/else block is to test for two 
            # possible situations; the if block will run if the actor's name is 
            # more than one word (an example of an actor whose name is one word 
            # would be 'Elvis'). The else block will run if the the name of the 
            # actor is one word. 
            movie = movie.split()
            movie_name = get_movie_name(movie)   
            if actor_dict.get(name):
                if (actor_dict[name]).count(movie_name) == 0:
                    (actor_dict[name]).append(movie_name)
            else:
                actor_dict[name] = [movie_name]
            line = actor_data.readline()
        else:
        # If the line does not start with letters, then it must be a line that
        # only contains movie information, and because the variable 'name'
        # hasn't been updated it will still equal the name of the actor in the 
        # current actor block.
            movie = line.split()
            movie_name = get_movie_name(movie)
            if movie_name != '' and (actor_dict[name]).count(movie_name) == 0:
            # The second part of this if statement must be included in case two
            # actors with the same name were in the same movie.
                actor_dict[name].append(movie_name)
            line = actor_data.readline()
    return actor_dict    

def invert_actor_dict(actor_dict):
    '''Return a dictionary that is the inverse of actor_dict. The original 
    actor_dict maps actors (string) to lists of movies (string) in which they 
    have appeared. The returned dictionary maps movies (string) to lists of 
    actors (string) appearing in the movie.'''
    
    movie_dict = {}
    for actor in actor_dict:
        for movie in actor_dict[actor]:
            if not movie_dict.get(movie):
                movie_dict[movie] = [actor]
            else:
                (movie_dict[movie]).append(actor)
    return movie_dict


def find_connection(actor_name, actor_dict, movie_dict):
    '''Return a list of (movie, actor) tuples (both elements of type string) 
    that represent a shortest connection between actor_name and Kevin Bacon that
    can be found in the actor_dict and movie_dict. (These dictionaries were 
    produced by parse_actor_data and invert_actor_dict, respectively.) Each 
    tuple in the returned list has a special property: the actor from the 
    previous tuple and the actor from the current tuple both appeared in the 
    stated movie. For the first tuple, the "actor from the previous tuple" is 
    actor_name, and the last tuple must contain Kevin Bacon. If there is no 
    connection between actor_name and Kevin Bacon, the returned list is 
    empty.'''
    
    actor_name = actor_name.title()
    connection_list = []
    if actor_name == 'Kevin Bacon':
        return connection_list
    if not actor_dict.get(actor_name):
        return connection_list
    distance_dict = {actor_name:0}
    rev_dist_dict = {0:actor_name}
    # distance_dict and rev_dist_dict are two dictionaries; distance_dict has 
    # actors as keys and their distance from actor_name is their value, while
    # rev_dist_dict has numbers as its keys and the values of the keys are lists
    # of actors who are that distance form actor_name.
    investigated = []
    not_investigated = [actor_name]
    # The investigated list is actors who have already been checked out to see 
    # if they are Kevin Bacon, and the distance_dict and rev_dist_dict have been 
    # updated to include them. Before an actor gets moved from not_investigated 
    # to investigated all of the actors that are in the movies they are in get 
    # added to not_investigated. 
    while len(not_investigated) > 0:
        element = not_investigated[0]
        investigated.append(element)
        for movie in actor_dict[element]:
            for actor in movie_dict[movie]:
                if investigated.count(actor) == 0 and \
                   not_investigated.count(actor) == 0:
                    distance_dict[actor] = distance_dict[element] + 1
                    if (rev_dist_dict.keys()).count(distance_dict[actor]) == 0:
                        rev_dist_dict[distance_dict[actor]] = [actor]
                    else:
                        (rev_dist_dict[distance_dict[actor]]).append(actor)
                    # This if/else block, and the line before it, updates 
                    # distance_dict or rev_dist_dict; these dictionaries are 
                    # important for making connection_list once Kevin Bacon has 
                    # been found. 
                    not_investigated.append(actor)
                    if actor == 'Kevin Bacon':
                        count = distance_dict['Kevin Bacon'] - 1
                        while count > 0:
                            for actor_2 in rev_dist_dict[count]:
                        # This for loop gets from Kevin Bacon back to 
                        # actor_name, and updates the connection list each time 
                        # a connection is found. It is possible for there to be
                        # different paths back to actor_name, but even if there
                        # are this will always find one of the shortest ones.     
                                for movie_2 in actor_dict[actor_2]:
                                    if (actor_dict[actor]).count(movie_2) != 0 \
                                       and count > 0:
                                        connection_list.append((movie_2, actor))
                                        actor = actor_2
                                        count -= 1
                        condition = 0
                        for movie in actor_dict[actor]:
                            if (movie_dict[movie]).count(actor_name) != 0 and \
                               condition == 0:
                                connection_list.append((movie, actor))
                                condition += 1
                        # There was some key error in the first for loop that
                        # seems to happen for no good reason for some actors,
                        # where the value of actor_2 will be equal to the first
                        # letter of actor_name, which will cause 
                        # actor_dict[actor_2] on line 169 to get a key error. 
                        # This lower for loop is what should be the last 
                        # iteration of the above for loop.
                        connection_list.reverse()
                        return connection_list
        not_investigated = not_investigated[1:]
    return connection_list

