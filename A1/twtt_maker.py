import os

x = os.listdir('C:\Users\Devon\Documents\A1\\tweets')

for item in x:
    in_file = 'C:\Users\Devon\Documents\A1\\tweets\\' + item
    out_file = item + '.twt'
    os.system('twtt.py "%s" "%s"' % (in_file, out_file))