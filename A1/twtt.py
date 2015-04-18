import re
import sys
import NLPlib

def do_all(tweet):
    '''Applies all of the below tweet modifications to the passsed in string. 
    Returns a string.'''
    tweet = detag(tweet)
    tweet = asciify(tweet)
    tweet = deurl(tweet)
    tweet = detwit(tweet)
    tweet = split_tokens(tweet)
    tweet = split_clitic(tweet)
    tweet = tag_tweet(tweet)
    tweet = demarc(tweet)
    return tweet

def detag(tweet):
    '''Removes html tags from the passed in string. Returns a string.'''
    y = re.search("<a.*?>(.*?)</a>", tweet)
    if y:
        tweet = re.sub("<a.*?>(.*?)</a>", y.group(1), tweet, 1)
        tweet = detag(tweet)
    return tweet

def asciify(tweet):
    '''Formats non-formatted characetrs in the passed in string. Returns a string.'''
    tweet = re.sub("&amp;", "&", tweet)
    tweet = re.sub("&quot;", "\"", tweet)
    tweet = re.sub("&lt;", "<", tweet)
    tweet = re.sub("&gt;", ">", tweet)
    tweet = re.sub("&#039;", "'", tweet)
    #if re.findall("&.*?;", tweet) != []:
        #print re.findall("&.*?;", tweet)
        #print tweet
    return tweet
        

def deurl(tweet):
    '''Removes urls from the passed in string. Returns a string.'''
    tweet = tweet.split()
    to_remove = []
    for token in tweet:
        if token.startswith('http') or token.startswith('www') or \
           token.find(".com") != -1 or token.find('.org') != -1 or \
           token.find('.gov') != -1:
            to_remove.append(token)
        elif re.findall("\S+?[.]\S+?/\S*", token):
            to_remove.append(token)
        #elif token.find('.') != -1:
            #print token
    if len(tweet) > 0:
        new_tweet = ''
        for num in range(0, len(tweet)):
            if not tweet[num] in to_remove:
                new_tweet += tweet[num] + ' '
        if len(new_tweet) > 0:        
            return new_tweet[:-1]
    return ""

def detwit(tweet):
    '''Removes leading @'s and #'s from the words of the passed in string. 
    Returns a string.'''
    tweet = tweet.split()
    for num in range(len(tweet)):
        if tweet[num].startswith("#") or tweet[num].startswith("@"):
            tweet[num] = tweet[num][1:]
        elif tweet[num].startswith("-#") or tweet[num].startswith("-@"):
            tweet[num] = '-' + tweet[num][2:]
        if tweet[num].startswith(".#") or tweet[num].startswith(".@"):
            tweet[num] = tweet[num][2:]        
    if len(tweet) > 0:
        new_tweet = tweet[0]
        for num in range(1, len(tweet)):
            new_tweet += " " + tweet[num]
        return new_tweet
    else:
        return ""

def start_punc(token):
    
    poss_punc = re.findall("^(\W+)\w+", token)
    if poss_punc != []:
        if poss_punc[0] == '#' or poss_punc[0] == '@':
            ret_tweet = token[1:] + ' '
        else:
            word = token.split(poss_punc[0])[1]
            if poss_punc[0].find('.') != -1 or poss_punc[0].find('!') != -1\
               or poss_punc[0].find('?') != -1:
                if not re.findall("^\w*$", word):
                    ret_tweet = consec_punc(poss_punc[0]) + ' \n ' + split_punc(word)
                else:
                    ret_tweet = consec_punc(poss_punc[0]) + ' \n ' + word                    
            else:
                if not re.findall("^\w*$", word):
                    ret_tweet = consec_punc(poss_punc[0]) + ' ' + split_punc(word)                
                else:
                    ret_tweet = consec_punc(poss_punc[0]) + ' ' + word
        return [True, ret_tweet]
    return [False, '']
    
def end_punc(token):
    
    poss_punc = re.findall("[\w-]*(\W+)$", token)
    if poss_punc != []:
        if poss_punc[0] == token:
            ret_tweet = token
        elif token in abbrevs:
            ret_tweet = token
        elif poss_punc[0] == ')' or poss_punc[0] == ',' or \
             poss_punc[0] == ';' or poss_punc[0] == '\'' or \
             poss_punc[0] == '"' or poss_punc[0] == '/' or \
             poss_punc[0] == ':':
            word = token.split(poss_punc[0])[0]
            if word == '':
                ret_tweet = consec_punc(poss_punc[0]) + ' '
            else:
                if not re.findall("^\w*$", word):
                    ret_tweet = split_punc(word) + ' ' + consec_punc(poss_punc[0]) + ' '          
                else:
                    ret_tweet = word + ' ' + consec_punc(poss_punc[0]) + ' '            
        else:
            word = token.split(poss_punc[0])[0]
            if word == '':
                ret_tweet = consec_punc(poss_punc[0]) + ' \n'
            else:
                if not re.findall("^\w*$", word):
                    ret_tweet = split_punc(word) + ' ' + consec_punc(poss_punc[0]) + ' \n'          
                else:
                    ret_tweet = word + ' ' + consec_punc(poss_punc[0]) + ' \n'
        return [True, ret_tweet]
    return [False, '']

def middle_punc(token):

    poss_punc = re.findall("\w+(\W+)\w+", token)    
    if poss_punc:   
        if poss_punc[0] == "'" or poss_punc[0] == '-':
            ret_tweet = token
        elif re.findall("^[\d,.]+$", token):
            ret_tweet = token
        else:
            token = token.split(poss_punc[0], 1)
            if poss_punc[0].find('.') != -1 or poss_punc[0].find('!') != -1 or \
               poss_punc[0].find('?') != -1:
                if not re.findall("^\w*$", token[1]):
                    ret_tweet = token[0] + ' ' + consec_punc(poss_punc[0]) +  \
                        ' \n ' + split_punc(token[1])
                else:
                    ret_tweet = token[0] + ' ' + consec_punc(poss_punc[0]) +  \
                        ' \n ' + token[1]
            else:
                if not re.findall("^\w*$", token[1]):
                    ret_tweet = token[0] + ' ' + consec_punc(poss_punc[0]) +  \
                        ' ' + split_punc(token[1])
                else:
                    ret_tweet = token[0] + ' ' + consec_punc(poss_punc[0]) +  \
                        ' ' + token[1]  
        #print ret_tweet
        return [True, ret_tweet]
    return [False, '']

def split_punc(token):
    
    ret_tweet = ''
    if token.startswith('('):
        ret_tweet += '( '
        token = token[1:]
    if re.findall("^\d\d?:\d\d[a|p|A|P][m|M]|\d\d?:\d\d$", token):
        return ret_tweet + token + ' '
    temp_punc = end_punc(token)
    if temp_punc[0] == True:
        return ret_tweet + temp_punc[1]
    temp_punc = start_punc(token)
    if temp_punc[0] == True:
        return ret_tweet + temp_punc[1]                
    temp_punc = middle_punc(token)
    if temp_punc[0] == True:
        return ret_tweet + temp_punc[1]
    #if not re.findall("^\w*$", token):
        #print token
    return token
    
def split_tokens(tweet):
    tweet = tweet.split(' ')
    ret_tweet = ''
    for token in tweet:
        ret_tweet += split_punc(token) + ' '
        #if len(ret_tweet) > 2 and ret_tweet[-2] == '\n':
            #ret_tweet = ret_tweet[:-1]
    return ret_tweet[:-1]
        
def split_clitic(tweet):
    tweet = tweet.split(' ')
    ret_tweet = ''
    for token in tweet:
        poss_end = re.findall("\w+('\w+)", token)
        if poss_end != []:
            root_word = token.split(poss_end[0])[0]
            ret_tweet += root_word + ' ' + poss_end[0] + ' '
        else:
            ret_tweet += token + ' '
    return ret_tweet.strip()

def consec_punc(punc):
    
    ret_punc = ''
    i = 0
    for num in range(len(punc) - 1):
        if punc[num] != punc[num+1]:
            ret_punc += punc[i:num+1] + ' '
            i = num+1
    if not (i == len(punc) - 1 and (punc[i] == '@' or punc[i] == '#')):
        ret_punc += punc[i:]
    return ret_punc.strip()

def tag_tweet(tweet):
    tweet = tweet.split(' ')
    tweet_tags = tagger.tag(tweet)
    ret_tweet = ''
    for num in range(len(tweet)):
        if tweet[num] == '\n':
            #print ret_tweet
            #print ret_tweet[:-1]
            #ret_tweet += '\n'
            ret_tweet = ret_tweet[:-1] + '\n'
        else:
            ret_tweet += tweet[num] + '/' + tweet_tags[num] + ' '
    return ret_tweet[:-1]

def demarc(tweet):
    return tweet + '\n|\n'

if __name__ == '__main__':
    

    tagger = NLPlib.NLPlib()

    abbrevs = ['Ala.', 'Ariz.', 'Assn.', 'Atty.', 'Aug.', 'Ave.', 'Bldg.', \
               'Blvd.', 'Calif.', 'Cf.', 'Ch.', 'Co.', 'Colo.', 'Conn.', \
               'Corp.', 'DR.', 'Dec.', 'Dept.', 'Dist.', 'Ed.', 'Eq.', 'FEB.', \
               'Feb.', 'Fla.', 'Ga.', 'Ill.', 'Inc.', 'JR.', 'Jan.', 'Jr.', \
               'Kan.', 'Ky.', 'La.', 'Ltd.', 'Mar.', 'Mass.', 'Md.', 'Mich.', \
               'Minn.', 'Mo.', 'Mt.', 'NO.', 'No.', 'Nov.', 'Oct.', 'Okla.', \
               'Op.', 'Ore.', 'Pa.', 'Pp.', 'Prof.', 'Prop.', 'Rd.', 'Rev.', \
               'Rte.', 'Sept.', 'Sr.', 'St.', 'Stat.', 'Supt.', 'Tech.', \
               'Tex.', 'Va.', 'Vol.', 'Wash.', 'al.', 'av.', 'ave.', 'ca.', \
               'cc.', 'chap.', 'cm.', 'cu.', 'dia.', 'dr.', 'eqn.', 'etc.', \
               'ft.', 'gm.', 'hr.', 'in.', 'kc.', 'lb.', 'lbs.', 'mg.', 'ml.', \
               'mm.', 'mv.', 'nw.', 'oz.', 'pl.', 'pp.', 'sec.', 'sq.', 'st.', \
               'yr.', 'Capt.', 'Col.', 'Dr.', 'Drs.', 'Fig.', 'Figs.', 'Gen.', \
               'Gov.', 'HON.', 'MR.', 'MRS.', 'Messrs.', 'Miss.', 'Mmes.', \
               'Mr.', 'Mrs.', 'Ref.', 'Rep.', 'Reps.', 'Sen.', 'fig.', \
               'figs.', 'vs.', 'Lt.', 'e.g.', 'i.e.', 'U.K.', 'U.S.', 'B.C.', \
               'p.m.', 'P.M.', 'A.M.', 'a.m.']    
    
    if len(sys.argv) > 2:
        given_file = sys.argv[1]
        output_file = sys.argv[2]
    else:
        given_file = ".\\tweets\\aplusk"
        output_file = 'twtt_output.txt'
    f = open(given_file, 'r')
    g = open(output_file, 'w')
    
    
    line = f.readline()
    while line != '':
        #print line
        #if line.find('atlantisweather') != -1:
            #print line
        g.write(do_all(line))
        #print split_clitic(split_tokens(asciify(detwit(deurl(detag(line))))))
        #print detwit(deurl(detag(line)))[22]
        line = f.readline()
    
    f.close()
    g.close()
    
