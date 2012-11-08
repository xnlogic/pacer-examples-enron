#!/usr/bin/env python
import glob
import operator
import time
import string
import re
import os
import cPickle as pickle

import nltk
from unidecode import unidecode

start = time.time()

stopwords = set(nltk.corpus.stopwords.words('english'))
NOT_WORD = re.compile(u'[^a-z ]+')
REPLY = re.compile(u'-----Original Message-----')

filenames = glob.glob('enron_*.txt')

words = {}
doc_words = {}
num_docs = 0

if not os.path.isfile('data.dump'):
    for filename in filenames:
        with open(filename, 'r') as f:
            for line in f:
                num_docs += 1

                line = line.lower()
                email = line.split()

                body = " ".join(email[2:])
                body = unidecode(unicode(body))
                body = NOT_WORD.sub(" ", body)
                word_list = body.split()

                words_in_doc = set()
                for word in word_list:
                    if word not in stopwords:
                        if word not in words_in_doc:
                            words_in_doc.add(word)

                        if words.has_key(word):
                            words[word] += 1
                        else:
                            words[word] = 1
                for word in words_in_doc:
                    if doc_words.has_key(word):
                        doc_words[word] += 1
                    else:
                        doc_words[word] = 1

    with open('data.dump', 'w') as f:
        pickle.dump([words, doc_words, num_docs], f)
else:
    with open('data.dump', 'r') as f:
        words, doc_words, num_docs = pickle.load(f)

num_words = len(words)

word_list = []

min_df = 505
max_df = 0.50 * num_docs

stopwords = []
for word, count in doc_words.iteritems():
    if count < min_df or count > max_df:
        stopwords.append(word)


stopwords.extend(['enron', 'subject', 'www', 'com', 'http', 'https', 'cc', 'message', 'sent', 're', 'ect', 'etc', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'll', 'am', 'pm'])
stopwords.extend(nltk.corpus.stopwords.words('english'))

with open('stopwords.txt', 'w') as f:
    for w in stopwords:
        print >>f, w

finish = time.time()
time_in_secs = finish-start
time_in_mins = time_in_secs/60.0
print "took: {0:0.2f} minutes to run, or {1} seconds".format(time_in_mins, time_in_secs)
