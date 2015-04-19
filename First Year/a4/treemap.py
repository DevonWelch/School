import directory_file
import display


directory = display.choose_directory()
if directory.endswith('\r'):
    directory = directory[:-1]
d = directory_file.Directory(directory)
d.determine_children_ratio()
display.display_tree(d, 1024, 768)
