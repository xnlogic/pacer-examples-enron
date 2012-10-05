#!/usr/bin/env bash

# Script to start jirb with more memory than normal

echo "Loading..."
echo ""
echo "NB: First time users, load the GraphML data into memory with:"
echo "        enron = Pacer::Examples::Enron.load_data"
echo ""
echo "    Examples are simple methods on this Enron class and the raw graph"
echo "    is available at enron.g"
echo ""

jruby -J-Xmx3000m -S irb -r lib/enron

