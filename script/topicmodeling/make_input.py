#!/usr/bin/env python
import lxml.etree as et

graphml = {
        "graph": "{http://graphml.graphdrawing.org/xmlns}graph",
        "node": "{http://graphml.graphdrawing.org/xmlns}node",
        "edge": "{http://graphml.graphdrawing.org/xmlns}edge",
        "data": "{http://graphml.graphdrawing.org/xmlns}data",
        "label": "{http://graphml.graphdrawing.org/xmlns}data[@key='label']",
        "x": "{http://graphml.graphdrawing.org/xmlns}data[@key='x']",
        "y": "{http://graphml.graphdrawing.org/xmlns}data[@key='y']",
        "size": "{http://graphml.graphdrawing.org/xmlns}data[@key='size']",
        "r": "{http://graphml.graphdrawing.org/xmlns}data[@key='r']",
        "g": "{http://graphml.graphdrawing.org/xmlns}data[@key='g']",
        "b": "{http://graphml.graphdrawing.org/xmlns}data[@key='b']",
        "weight": "{http://graphml.graphdrawing.org/xmlns}data[@key='weight']",
        "edgeid": "{http://graphml.graphdrawing.org/xmlns}data[@key='edgeid']"
}

def main():
    tree = et.parse('enron_data.graphml')
    start = time.time();
    message_nodes = tree.xpath('/*/gml:graph/gml:node/gml:data[@key="type" and text()="Message"]', namespaces={'gml': 'http://graphml.graphdrawing.org/xmlns'});
    finish = time.time();
    print "elapsed: {0:0.2f} mins".format((finish-start)/60.0)

def write_to_file(messages):
    total = len(messages)
    offset = 0
    limit = 10000

    while offset < total:
        batch = messages[offset:offset+limit]
        file_out = open('enron_{0}_{1}.txt'.format(offset,offset+limit), 'w')
        for msg in batch:
            email_id = msg.getparent().xpath('gml:data[@key="emailID"]', namespaces={'gml': 'http://graphml.graphdrawing.org/xmlns'})[0].text
            body = msg.getparent().xpath('gml:data[@key="body"]', namespaces={'gml': 'http://graphml.graphdrawing.org/xmlns'})[0].text.replace('\n', ' ')
            file_out.write('{0} enron {1}\n'.format(email_id, body))
        file_out.close()
        offset += limit
