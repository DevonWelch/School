import pygame
import os
import os.path
import media
from directory_file import Directory


# Originally there was going to be a make_tree function, but I discovered that
# it was unnecessary because the __init__ method in the directory/file classes
# creates the tree on its own. 


def display_tree(top_dir, width, height):
    '''(Directory) -> NoneType
    Using pygame, creates a visual representation of the directory top_dir, in 
    the form of a treemap.'''

    original_dir = top_dir
    pygame.init()
    screen_size = (width, height)
    screen = pygame.display.set_mode(screen_size)
    running = True
    pix_dict = {}
    # The purpose of pix_dict is to map all of the pixels to a file or 
    # directory.
    setup_screen(top_dir, screen, width, height, pix_dict)
    while running:
        event = pygame.event.poll()
        if event.type == pygame.QUIT:
            running = False
        elif event.type == pygame.MOUSEMOTION:
            draw(top_dir, screen, 0, 0, width, height, pix_dict)
            blit_current_subdir(screen, width, height, event, pix_dict)
            pygame.display.flip()
	elif event.type == pygame.MOUSEBUTTONDOWN:
	    if event.button == 1:
		# If you press the left mouse button, you will be taken to the
		# display of the directory you clicked on, or if you clicked
		# on a file, the directory that that file belongs to.
		if event.pos in pix_dict:
		    if os.path.isdir(pix_dict[event.pos]) and \
		       pix_dict[event.pos] != top_dir:
			n = Directory(pix_dict[event.pos])
			pix_dict = {}
			_go_to_next_dir(n, screen, width, height, pix_dict)
			top_dir = n
		    elif not os.path.isdir(pix_dict[event.pos]):
			temp_str = pix_dict[event.pos]
			n = Directory(get_parent_from_str(temp_str))
			pix_dict = {}
			_go_to_next_dir(n, screen, width, height, pix_dict)
			top_dir = n
	    elif event.button == 2:
		# If you press the mouse wheel, you will be taken back to the 
		# display of the original directory.
		top_dir = original_dir
		pix_dict = {}
		setup_screen(top_dir, screen, width, height, pix_dict)
	    elif event.button == 3:
		# If you click the right mouse button, you will be taken to the
		# display of the directory one above the one currently 
		# displayed.
		if top_dir.route != original_dir.route:
		    n = Directory(top_dir.parent)
		    pix_dict = {}
		    _go_to_next_dir(n, screen, width, height, pix_dict)
		    top_dir = n
    pygame.quit()


def draw(directory, screen, x, y, width, height, pix_dict):
    '''(Directory, screen, int, int, int, int, dict) -> NoneType
    Recursively draws everything from directory onto a pygame surface, but does
    not flip the display. Also updates pix_dict with what directory or file is 
    located at every pixel.'''

    y_changing = y
    x_changing = x

    _draw_next_file(directory, screen, x, y, width, height)
    update_pix_dict(pix_dict, directory, x, y, width, height)
    first = True
    for child in directory.children:
        if os.path.isdir(child.route):
	    # This code does not display directories and the files of
	    # directories that are relatively too small, because if there are 
	    # too many they will not display correctly. In addition, some 
	    # directories might be displayed but their contents may not be 
	    # visible because they have no empty space displayed; their contents
	    # can be viewed by inspecting the directory.
            if height >= width:
		if first:
                    y_changing += 5
                    height -= 2
                    first = False
		if int(height * child.ratio) > 4:
		    draw(child, screen, x + 5, y_changing, width - 10, \
		         int(height * child.ratio) - 4, pix_dict)
		    y_changing += int(height * child.ratio)
            else:
		if first:
                    x_changing += 5
                    width -= 2
                    first = False
		if int(width * child.ratio) > 4:
		    draw(child, screen, x_changing, y + 5, \
		         int(width * child.ratio) - 4, height - 10, pix_dict)
		    x_changing += int(width * child.ratio)
        else:
            if height >= width:
                if first:
                    y_changing += 4
                    height -= 2
                    first = False
                _draw_next_file(child, screen, x + 4, y_changing, \
                    width - 5, int(height * child.ratio))
                update_pix_dict(pix_dict, child, x + 4, y_changing, \
		    width - 5, int(height * child.ratio))
                y_changing += int(height * child.ratio)
                if int(height * child.ratio) == 1:
                    y_changing += 1
            else:
                if first:
                    x_changing += 4
                    width -= 2
                    first = False
                _draw_next_file(child, screen, x_changing, y + 4, \
                    int(width * child.ratio), height - 5)
                update_pix_dict(pix_dict, child, x_changing, y + 4, \
		    int(width * child.ratio), height - 5)
                x_changing += int(width * child.ratio)
                if int(width * child.ratio) == 1:
                    x_changing += 1


def _draw_next_file(file, screen, x, y, width, height):
    '''(File, screen, int, int, int, int) -> NoneType
    Draws a file or directory onto a pygame surface; files are drawn as solid 
    rectangles, directories are drawn as hollow rectangles with edges 4 pixels 
    thick.'''

    white = (255, 255, 255)
    if os.path.isdir(file.route):
	# It is not determined here, but if a directory would be less than 8 
	# pixels wide or tall, neither it nor its children will be displayed.
        pygame.draw.rect(screen, white, (x, y, width, height), 4)
    else:
	# If a file's directory was big enough to display, the file will be 
	# displayed.
	if height < 3:
	    height = 3
	if width < 3:
	    width = 3
	if height > width:
	    pygame.draw.rect(screen, file.colour, (x, y, width - 1, height - 2))
	else:
	    pygame.draw.rect(screen, file.colour, (x, y, width - 2, height - 1))

def update_pix_dict(pix_dict, file, x, y, width, height):
    '''(dict, int, int, int, int, int) -> NoneType
    Updates a pixel dictionary with all of the pixels that are covered by the 
    current file or directory.'''

    if os.path.isdir(file.route):
        x_coords = increase_list(range(width), x)
	x_coords_corners = x_coords[:4] + x_coords[-4:]
	y_coords = increase_list(range(height), y)
	y_coords_corners = y_coords[:4] + y_coords[-4:]
	# The reason for the corner lists is that unlike how it works for files,
	# the pixel location of directories is not simply everything from their
	# minimum x to their maximum x crossed with everything form their 
	# minimum y to their maximum y, because there is a hole. So the corner
	# lists are the x or y values of the pixels of each side. 
	for number in x_coords_corners:
            for second_number in y_coords:
                pix_dict[(number, second_number)] = file.route
	for number in x_coords:
            for second_number in y_coords_corners:
                pix_dict[(number, second_number)] = file.route
    else:
	if width < 3:
	    width = 3
	if height < 3:
	    height = 3
        x_coords = increase_list(range(width), x)
	x_coords = x_coords[:-2]
        y_coords = increase_list(range(height), y)
	y_coords = y_coords[:-2]
        for number in x_coords:
            for second_number in y_coords:
                pix_dict[(number, second_number)] = file.route


def blit_current_subdir(screen, width, height, event, pix_dict):
    '''(screen, int, int, event, dict) -> NoneType
    Blits the directory or file that th mouse is currentl on onto the pygame 
    display; does not flip the pygame display.'''

    coord = (event.pos)
    black = (0, 0, 0)
    font = pygame.font.Font(None, 24)
    if event.pos in pix_dict:
	if os.path.isdir(pix_dict[event.pos]):
	    text_surface = font.render('current directory is %s' \
	                                % pix_dict[event.pos], 1, black)
        else:
	    text_surface = font.render('current file is %s' \
	                                % pix_dict[event.pos], 1, black)
        text_pos = (0, 0)
        screen.blit(text_surface, text_pos)

def increase_list(list, int):
    '''(list, int) -> list
    Returns a copy of list where every value has been increased by int. 
    Precondition: all values must be ints or floats.'''

    new_list = []
    for number in list:
	new_list.append(number + int)
    return new_list


def get_parent_from_str(str):
    '''(str) -> str
    Returns a string which is the route of the parent of the file or directory
    denoted by the input string.'''
    
    x = str.rfind('\\')
    if x != -1:
	new_str = str[:x]
    else:
	x = str.rfind('/')
	new_str = str[:x]
    return new_str

def _go_to_next_dir(directory, screen, width, height, pix_dict):
    '''(Directory, screen, int, int, dict) -> NoneType
    Sets up the next directory to display using pygame, draws it on the 
    screen, then flips the display.'''
    
    directory.determine_children_ratio()
    temp_str = directory.route
    directory.parent = get_parent_from_str(temp_str)
    setup_screen(directory, screen, width, height, pix_dict)
    
def setup_screen(directory, screen, width, height, pix_dict):
    '''(Directory, screen, int, int, dict) -> NoneType
    Sets the background of the screen balck and draws the current directory on 
    top in a treemap fashion.'''
    
    black = (0, 0, 0)
    screen.fill(black)
    draw(directory, screen, 0, 0, width, height, pix_dict)
    pygame.display.flip()

def choose_directory():
    '''(NoneType) -> str
    Returns a string of the chosen directory.'''

    d = str(media.choose_folder())
    d = d.replace('/', '\\')
    d.strip('u')
    d.strip("'")
    return d