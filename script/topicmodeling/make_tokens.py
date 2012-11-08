#!/usr/bin/env python
import glob
import operator
import time
import string
import re
import os

import nltk
from unidecode import unidecode

start = time.time()

NOT_WORD = re.compile(u'[^a-z ]+')

filenames = glob.glob('enron_*.txt')
stopwords = set()
with open('stopwords.txt', 'r') as f:
    for l in f:
        stopwords.add(l.strip())

for filename in filenames:
    with open(filename, 'r') as f:
        with open('tokenized_{0}'.format(filename), 'w') as o:
            for line in f:
                line = line.lower()
                email = line.split()

                out_doc = email[:2]

                body = " ".join(email[2:])
                
                # get rid of message bodies that are forwarded or replied
                try:
                    fwd_index = body.index('---------------------- Forwarded')
                    body = body[:fwd_index]
                except ValueError:
                    pass

                try:
                    reply_index = body.index('-----Original Message-----')
                    body = body[:reply_index]
                except ValueError:
                    pass

                body = unidecode(unicode(body))
                body = NOT_WORD.sub(" ", body)
                word_list = body.split()

                tokens = set()
                for word in word_list:
                    if word not in stopwords:
                        tokens.add(word)

                out_doc.extend(list(tokens))
                print >>o, " ".join(out_doc)
        print "done processing {0}".format(filename)

finish = time.time()
time_in_secs = finish-start
time_in_mins = time_in_secs/60.0
print "took: {0:0.2f} minutes to run, or {1} seconds".format(time_in_mins, time_in_secs)
