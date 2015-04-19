import pygame
import os
import os.path


class File(object):

    def __init__(self, n, p=None):

        self.name = n
        self.parent = p
        self.route = self._get_route()
        self.size = float(os.path.getsize(self.route))
        self.colour = _get_random_colour()
        self.ratio = None
        self.area = None

    def __repr__(self):

        return self.name

    def _get_route(self):
        '''(NoneType) -> str
        Returns the full route of the current file in string format.'''

        if self.parent == None:
            return self.name
        else:
            return os.path.join(self.parent._get_route(), self.name)


class Directory(File):

    def __init__(self, n, p=None):

        self.name = n
        self.parent = p
        self.route = self._get_route()
        self.children = self._get_children()
        self.size = float(os.path.getsize(self.route))
        self.total_size = self._calculate_total_size()
        self.ratio = 1
        self.area = None

    def _get_children(self):
        '''(NoneType) -> list
        Returns a list of the children of the current directory.'''
        # It is important to remember that because _get_children is called in
        # the __init__ method and the __init__ method is called in the
        # _get_children method, this will recursively loop until the entire
        # tree has been made.

        print self.route
        children = os.listdir(self.route)
        child_list = []
        for child in children:
            temp_route = os.path.join(self.route, child)
            if os.path.isdir(temp_route):
                try:
                    child_list.append(Directory(child, self))
                except:
                    happy = 'sad'
            else:
                try:
                    child_list.append(File(child, self))
                except:
                    happy = 'sad'
        return child_list

    def _calculate_total_size(self):
        '''(NoneType) -> int
        Returns the total size of the directory, which includes the size of the
        directory and all of its children.'''

        size = os.path.getsize(self.route)
        for child in self.children:
            if os.path.isdir(child.route):
                size += child._calculate_total_size()
            else:
                size += os.path.getsize(child.route)
        return float(size)

    def determine_children_ratio(self):
        '''(NoneType) -> NoneType
        Updates all of the files and directories in the top directory with an
        instance variable self.ratio, which is their size relative to their
        parent.
        Precondition: directory is not empty and none of the subdirectories
        are empty either.'''
        # Self.ratio cannot be given a value initially because _get_children is
        # called before _calculate_total_size, and the order of these calls
        # cannot be reversed because _calculate_total_size needs to know the
        # directory's children to give the correct size.

        for child in self.children:
            if os.path.isdir(child.route):
                child.determine_children_ratio()
            if self.total_size != 0 and self.total_size != self.size:
                if os.path.isdir(child.route):
                    child.ratio = (child.total_size / \
                        (self.total_size - self.size))
                else:
                    try:
                        child.ratio = (child.size / \
                            (self.total_size - self.size))
                    except:
                        child.ratio = 0


def _get_random_colour():
    '''(NoneType) -> tuple
    Returns a tuple with three values between 0 and 255 inclusive which can be
    used to make a colour.'''

    import random
    r = range(256)
    random.shuffle(r)
    g = range(256)
    random.shuffle(g)
    b = range(256)
    random.shuffle(b)
    colour = (r[0], g[0], b[0])
    return colour
