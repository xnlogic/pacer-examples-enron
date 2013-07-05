#!/usr/bin/env bash

# Script to start jirb with more memory than normal

echo "Loading..."
echo ""
echo "NB: First time users, load the GraphML data into memory with:"
echo "        enron = Enron.load_data"
echo ""
echo "    Examples are simple methods on this Enron class and the raw graph"
echo "    is available at enron.g"
echo ""

jirb -r lib/enron

