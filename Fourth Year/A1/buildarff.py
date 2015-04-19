import sys
import re

def make_classes(args):
    class_dict = {}
    for group in args[:-1]:
        twt_list = []
        name_given = False
        class_name = ''
        inds = group.split('+')
        if inds[0].find(':') != -1:
            class_name, inds[0] = inds[0].split(':')
            name_given = True
        for twt_file in inds:
            if name_given == False:
                class_name += twt_file[:-4]
            twt_list.append(twt_file)
        class_dict[class_name] = twt_list
    return class_dict

def count_features(tweet, class_name):
    sentences = tweet.split('\n')
    num_sent = len(sentences)
    all_tokens = []
    sent_len = 0.0
    for sent in sentences:
        split_sent = sent.split(' ')
        sent_len += len(split_sent)
        all_tokens += split_sent
    sent_len = sent_len / num_sent
    token_len = 0.0
    count_list = [0] * 17
    #FPP_count = 0
    #SPP_count = 0
    #TPP_count = 0
    #CC_count = 0
    #PTV_count = 0
    #FTV_count = 0
    #C_count = 0
    #CSC_count = 0
    #D_count = 0
    #P_count = 0
    #E_count = 0
    #CN_count = 0
    #PN_count = 0
    #A_count = 0
    #WH_count = 0
    #MSA_count = 0
    #UC_count = 0
    num_tokens = 0
    future_tense = False
    prev_token = ''
    for token in all_tokens:
        split_token = token.split('/')
        if len(split_token) == 3:
            split_token = ['/', 'NN']
        token_word, speech_part = split_token
        count_list = count_token(token_word, speech_part, count_list, future_tense)
        if prev_token == "going" and token_word == "to":
            future_tense = True
        else:
            future_tense = False
        prev_token = token_word
        if not re.match("^(#|[$]|[.]|,|:|\(|\)|\"|')$", speech_part) and \
           token_word != '/':
            token_len += len(token_word)
            num_tokens += 1
    return count_list + [sent_len, token_len/num_tokens, num_sent, class_name]

def count_token(token, speech_part, feature_count, future_tense):
    if re.match("^(i|me|my|mine|we|us|our|ours)$", token.lower()):
        feature_count[0] = feature_count[0] + 1
    elif re.match("^(you|your|yours|u|ur|urs)$", token.lower()):
        feature_count[1] = feature_count[1] + 1        
    elif re.match("^(he|him|his|she|her|hers|it|its|they|them|their|theirs)$", \
                  token.lower()):
        feature_count[2] = feature_count[2] + 1
    elif re.match("^('ll|will|gonna)$", token) or (future_tense and speech_part == "VB"):
        feature_count[5] = feature_count[5] + 1
    if re.match("^(smh|fwb|lmfao|lmao|lms|tbh|rofl|wtf|bff|wyd|lylc|brb)$", \
                  token):
        feature_count[15] = feature_count[15] + 1
    if re.match("^(atm|imao|sml|btw|bw|imho|fyi|ppl|sob|ttyl|imo|ltr|thx|kk)$",\
                token):
        feature_count[15] = feature_count[15] + 1
    if re.match("^(omg|ttys|afn|bbs|cya|ez|f2f|gtr|ic|jk|k|ly|ya|nm|np|plz)$",\
                token):
        feature_count[15] = feature_count[15] + 1
    if re.match("^(ru|so|tc|tmi|ym|ur|u|sol)$", token):
        feature_count[15] = feature_count[15] + 1
    if re.search("\w+", token) and token.upper() == token:
        feature_count[16] = feature_count[16] + 1
    if re.search(',', token):
        feature_count[6] = feature_count[6] + token.count(',')
    if re.search(';', token):
        feature_count[7] = feature_count[7] + token.count(';')
    if re.search(':', token):
        feature_count[7] = feature_count[7] + token.count(':')
    if re.search('-', token):
        feature_count[8] = feature_count[8] + token.count('-')      
    if re.search('\(', token):
        feature_count[9] = feature_count[9] + token.count('(')
    if re.search('\)', token):
        feature_count[9] = feature_count[9] + token.count(')')
    if token.count('.') > 2:
        feature_count[10] = feature_count[10] + 1
    if speech_part == "CC":
        feature_count[3] = feature_count[3] + 1
    elif speech_part == "VBD":
        feature_count[4] = feature_count[4] + 1
    elif speech_part == "NN" or speech_part == "NNS":
        feature_count[11] = feature_count[11] + 1    
    elif speech_part == "NNP" or speech_part == "NNPS":
        feature_count[12] = feature_count[12] + 1          
    elif speech_part == "RB" or speech_part == "RBR" or speech_part == "RBS":
        feature_count[13] = feature_count[13] + 1
    elif speech_part == "WDT" or speech_part == "WP" or speech_part == "WP$" \
         or speech_part == "WRB":
        feature_count[14] = feature_count[14] + 1        
    return feature_count
    
def count_all(classes, max_tweets):
    data_list = []
    for class_name in classes:
        for twt_file in classes[class_name]:
            data_list += (count_tweets(twt_file, class_name, max_tweets))
    return data_list

def count_tweets(twt_file, class_name, max_tweets):
    i = 0
    cur_tweet = ''
    feature_list = []
    f = open(twt_file)
    line = f.readline()
    while i != max_tweets and line != '':
        if line == '|\n':
            feature_list.append(count_features(cur_tweet[:-1], class_name))
            #print cur_tweet
            cur_tweet = ''
            i += 1
        else:
            cur_tweet += line
        line = f.readline()
    f.close()
    return feature_list
        

if __name__ == '__main__':
    
    attributes = ['FPP', 'SPP', 'TPP', 'CC', 'PTV', 'FTV', 'C', 'CSC', 'D', 'P',\
                  'E', 'CN', 'PN', 'A', 'WH', 'MSA', 'US', 'ALS', 'ALT', 'NS']
    
    if len(sys.argv) > 1:
        if sys.argv[1].startswith('-'):
            max_tweets = int(sys.argv[1][1:])
            classes = make_classes(sys.argv[2:])
        else:
            max_tweets = -1
            classes = make_classes(sys.argv[1:])
        output_file = sys.argv[-1]
        relation_name = output_file[:-5]
        data_list = count_all(classes, max_tweets)
        g = open(output_file, 'w')
        g.write('@relation %s\n\n' % output_file[:-5])
        for att in attributes:
            g.write('@attribute %s numeric\n' % att)
        class_list = ''
        for c in classes:
            class_list += c + ', '
        class_list = class_luist[:-2]            
        g.write('@attribute class {%s}\n\n@data\n' % class_list)
        for tweet in data_list:
            g.write("%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%s\n"\
                    % (tweet[0],tweet[1],tweet[2],tweet[3],tweet[4],tweet[5],\
                    tweet[6],tweet[7],tweet[8],tweet[9],tweet[10],tweet[11],\
                    tweet[12],tweet[13],tweet[14],tweet[15],tweet[16],\
                    tweet[17],tweet[18],tweet[19],tweet[20]))
        g.close()
    else:
        args = ['justinbieber.twt', 'britneyspears.twt']
        classes = make_classes(args)
        args2 = ['pop:rihanna.twt+katyperry.twt', 'bbcnews.twt+cnn.twt', 'popvnews.arff']
        classes2 = make_classes(args2)
        output_file = args2[-1]
        max_tweets = -1
        data_list = count_all(classes2, max_tweets)
        g = open(output_file, 'w')
        g.write('@relation %s\n\n' % output_file[:-5])
        for att in attributes:
            g.write('@attribute %s numeric\n' % att)
        class_list = ''
        for c in classes2:
            class_list += c + ', '
        class_list = class_list[:-2]
        g.write('@attribute class {%s}\n\n@data\n' % class_list)
        for tweet in data_list:
            g.write("%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%s\n"\
                    % (tweet[0],tweet[1],tweet[2],tweet[3],tweet[4],tweet[5],\
                    tweet[6],tweet[7],tweet[8],tweet[9],tweet[10],tweet[11],\
                    tweet[12],tweet[13],tweet[14],tweet[15],tweet[16],\
                    tweet[17],tweet[18],tweet[19],tweet[20]))
        g.close()
        

# make a list of pairs, first in pair is attribute, second in pair is 
# function to test if a token matches that attribute