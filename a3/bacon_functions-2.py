def get_movie_name(movie):
    
    movie_name = ''
    for element in movie:
        if element.startswith('('):
            if element[1:-1].isdigit():
                movie_name += element
                break
        else: 
            movie_name += element + ' '  
    return movie_name
  

def parse_actor_data(actor_data):
    
    actor_dict = {}
    current_actor = ''
    line = actor_data.readline()
    while not line.startswith('----\t'):
        line = actor_data.readline()
    line = actor_data.readline()
    while line != '' and not line.startswith('-----') :
        if line[0].isalpha():
            get_name = line.split(',')
            if len(get_name) > 1:
                get_name[1] = get_name[1].split()
                name = get_name[1][0] + ' ' + get_name[0]
            else: 
                name = (line.split())[0]
            name = name.title()
            if len(get_name) > 1:
                movie = line[(len(name)+1):]
            else:
                movie = line[(len(name)):]
            movie = movie.split()
            movie_name = get_movie_name(movie)                     
            actor_dict[name] = [movie_name]
            line = actor_data.readline()
        else:
            movie = line.split()
            movie_name = get_movie_name(movie)
            if movie_name != '':
                actor_dict[name].append(movie_name)
            line = actor_data.readline()
    return actor_dict    

def invert_actor_dict(actor_dict):
    
    movie_dict = {}
    for actor in actor_dict:
        for movie in actor_dict[actor]:
            if not movie_dict.get(movie):
                movie_dict[movie] = [actor]
            else:
                (movie_dict[movie]).append(actor)
    return movie_dict


def find_connection(actor_name, actor_dict, movie_dict):
    
    connection_list = []
    if not actor_dict.get(actor_name):
        return connection_list
    distance_dict = {actor_name:0}
    rev_dist_dict = {0:actor_name}
    investigated = []
    not_investigated = [actor_name]
    for element in not_investigated:
        movie_list = actor_dict[element]
        investigated.append(element)
        for movie in movie_list:
            for actor in movie_dict[movie]:
                if investigated.count(actor) == 0 and \
                   not_investigated.count(actor) == 0:
                    distance_dict[actor] = distance_dict[element] + 1
                    if (rev_dist_dict.keys()).count(distance_dict[actor]) == 0:
                        rev_dist_dict[distance_dict[actor]] = [actor]
                    else:
                        (rev_dist_dict[distance_dict[actor]]).append(actor)
                    not_investigated.append(actor)
                    if actor == 'Kevin Bacon':
                        connection_list.append((movie, actor))
                        count = distance_dict['Kevin Bacon'] - 1
                        while count > 0:
                            for actor_2 in rev_dist_dict[count]:
                                for movie_2 in actor_dict[actor_2]:
                                    if (actor_dict[actor]).count(movie_2) != 0:
                                        connection_list.append((movie_2, actor_2))
                                        actor = actor_2
                                        count -= 1
                                        break  
                        connection_list.reverse()
                        return connection_list
        not_investigated = not_investigated[1:]
    return connection_list

