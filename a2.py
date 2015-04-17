# No imports are allowed without the permission of your instructor.

# Definition: An "association list" is a list of lists, such as
#    [ [3, ["hello", 27.4, True]], ["drama", [13, "comedy", "goodbye", 1]] ]
# Each sublist has two elements: the first is called a "key" and is a value of
# any type, and the second is a list of values (of any type) that are
# associated with that key. No key occurs more than once in an association
# list.

# An "image association list" is an association list in which each key is a
# string and its associated list contains the names of image files that
# have that string in their img tag.
# Example:
#    [ ["madonna", ["img3541.jpg", "img1234.jpg"]], 
#      ["mtv", ["img2999.jpg", "img1234.jpg", "gaga.JPG", "gaga22.JPG"] ]

# Definition: A "filter description" is a string made up of one or more terms
# separated by "and". Each term is a sequence of characters surrounded by
# colons, with optionally the word "not" before it. Example:
#    :mtv: and not :madonna:


def process_filter_description(f, images, ial):
    '''Return a new list containing only images from list "images" that pass
    the filter description "f" according to image association list "ial".
    '''

    filtered_images = []
    list_of_filters = f.replace(" ", "")
    list_of_filters = list_of_filters.split("and")
    for filter in list_of_filters:
        filter = filter.strip()
    count = 0
    for image in images:
        for association in ial:
            key = association[0]
            images_in_ial = association[1]
            if list_of_filters.count(":" + key + ":") != 0 and \
            list_of_filters.count("not" + ":" + key + ":") == 0:
                count += 1
                if images_in_ial.count(image) != 0:
                    filtered_images.append(image)
    if count == 0:
        filtered_images.append(images)
    for image in images:
        for association in ial:
            key = association[0]
            images_in_ial = association[1]
            if list_of_filters.count("not" + ":" + key + ":") != 0:
                if images_in_ial.count(image) != 0:
                    if filtered_images.count(image) != 0:
                        filtered_images.remove(image)
    return filtered_images


   
   
def all_images(ial):
    '''Return a list of all the images in image association list "ial". 
    Exclude duplicates.
    '''
    
    list_of_images = []    
    for association in ial:
        images_in_ial = association[1]
        for image in images_in_ial:
            if list_of_images.count(image) == 0:
                list_of_images.append(image)
    return list_of_images
    


    
def record_associations(description, image, ial):
    '''Update the image association list "ial" with the tokens from str
    "description". "image" (a str) is the name of the image to be associated
    with the tokens in "description". Convert all tokens added to "ial" into
    lowercase to make matching easier.
    '''

    description_lower = description.lower()    
    list_of_tokens = description_lower.split()    
    counter = 0
    for token in list_of_tokens:
        for association in ial:
            key = association[0]
            images_in_ial = association[1]
            counter += 1
            if key == token:
                images_in_ial.append(image)
            elif counter == len(ial):
                ial.append([token, [image]])            
    return ial

    
     

       
def find_guts(s):
    '''Return the characters in str "s" that are contained within the
    outermost pair of matching single or double quotes. If there are no quotes
    or the outermost quotes don't match, return the empty string.
    '''
    
    guts_of_s = ""
    first_single = s.find("'") # Index of the first instance of a single quote.
    last_single = s.rfind("'") # Index of the last instance of a single quote.
    first_double = s.find('"') # Index of the first instance of a double quote.
    last_double = s.rfind('"') # Index of the last instance of a double quote.
    if first_single != last_single: 
# This ensures that there are at least two single quotes, because if there are 
# none first_single and last_single will equal -1 and if there is one they 
# will be the same value.
        if first_double == last_double:
# If this is the case, there is either 1 double quote or no double quotes.
            if first_double == -1:
                guts_of_s = s[first_single + 1:last_single]
                return guts_of_s
# Because there are no double quotes we can be sure that it is single quotes
# which are the outermost ones.
            elif (first_double < first_single) or (first_double > last_single):
                return guts_of_s
# If the double quote is outside of the outermost single quotes the empty string
# will be returned.
            elif first_double < first_single < last_double:
                guts_of_s = s[first_double + 1:last_double]
                return guts_of_s
# If the double quote is within the outermost single quotes then a new string 
# will be made from the characters between the outermost single quotes.
        elif first_double != last_double:
            if ((first_single < first_double) and \
               (last_single < last_double)) or\
               ((first_single > first_double) and \
               (last_single > last_double)):
                return guts_of_s
# This returns the empty string because the outermost quotes are not of the 
# same type.
            elif ((first_single < first_double) and \
                  (last_single > last_double)):
                guts_of_s = s[first_single + 1:last_single]
                return guts_of_s
# This returns the new string if the first and last quotes are single quotes.       
            elif ((first_single > first_double) and \
                  (last_single < last_double)):
                guts_of_s = s[first_double + 1:last_double]
                return guts_of_s
# This returns the new string if the first and last quotes are double quotes.
    elif first_single == last_single:
        if first_double == last_double:
            return guts_of_s
# This guarantees there are no matching quotes.
        elif first_double != last_double:
            if first_single == -1:
                guts_of_s = s[first_double + 1:last_double]
                return guts_of_s
# Because there are no single quotes we can be sure that it is double quotes
# which are the outermost ones.
            elif (first_single < first_double) or (first_single > last_double):
                return guts_of_s
# If the single quote is outside of the outermost double quotes the empty string
# will be returned.
            elif first_double < first_single < last_double:
                guts_of_s = s[first_double + 1:last_double]
                return guts_of_s
# If the single quote is within the outermost double quotes then a new string 
# will be made from the characters between the outermost double quotes.

    
    
def find_attribute_value(html_tag, att):
    '''Return the value of attribute "att" (a str) in the str "html_tag".  
    Return None if "att" doesn't occur in "html_tag".
    '''
    
    index_of_att = html_tag.find(att)
    if index_of_att == -1:
        return None
    else:
        separation = html_tag.find("=", index_of_att)
        beginning_of_key = html_tag.find("'", separation)
        if beginning_of_key == -1:
            beginning_of_key = html_tag.find('"', separation)
            end_of_key = html_tag.find('"', beginning_of_key + 1)
            key = html_tag[beginning_of_key + 1:end_of_key]
        else:
            end_of_key = html_tag.find("'", beginning_of_key)
            key = html_tag[beginning_of_key + 1:end_of_key]
        return key

    
def first(a, b):
    '''Return the smaller of the two ints "a" and "b", excluding -1. Both "a"
    and "b" are >= -1. If exactly one is -1, return the other. If both are -1,
    return -1.
    '''

    if a == -1 and b == -1:
        return -1
    elif a == -1 and b > -1:
        return b
    elif a > -1 and b == -1:
        return a
    elif a > b:
        return b
    elif a < b:
        return a

    
    
def process_page(webpage, ial):
    '''Update the image association list "ial" with the images found in the 
    text in "webpage" (a str).
    '''
    
    webpage_lower = webpage.lower()
    webpage_list = webpage_lower.split("<img")
    for tag in webpage_list:
        location_of_alt = tag.find("alt")
        location_of_separator = tag.find("=", location_of_alt)
        location_of_end_of_tag = tag.find(">", location_of_separator)
        location_of_next_equal_sign = tag.find ("=", location_of_separator + 1)
        first_quote = first(location_of_end_of_tag, location_of_next_equal_sign)
        find_alt_in = tag[location_of_separator:first_quote]
        alt_text = find_guts(find_alt_in)
        location_of_src = tag.find("src")
        location_of_separator = tag.find("=", location_of_src)
        location_of_end_of_tag = tag.find(">", location_of_src)
        location_of_next_equal_sign = tag.find("=", location_of_separator+1)
        first_quote = first(location_of_end_of_tag, location_of_next_equal_sign)
        find_image_name_in = tag[location_of_separator:first_quote]
        image_name = find_guts(find_image_name_in)
        record_associations(alt_text, image_name, ial)
    return ial
    
    

    
def clean_up(alist, list_threshold):
    '''Return a new association list that is a copy of "alist" except that any
    key-value list in alist whose value is longer than int "list_threshold" is
    not included.
    '''

    new_alist = []
    for association in alist:
        key = association[0]
        value_list = association[1]
        if len(value_list) <= list_threshold:
            new_alist.append(association)
    return new_alist


