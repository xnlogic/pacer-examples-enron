# load this file from jirb to import the db/enron_data.grapml file into
# a TinkerGraph
#

require 'pathname'
require 'pacer'

g = Pacer.tg
Pacer::GraphML.import g, Pathname.new(__FILE__).parent.parent + "db/enron_data.graphml"

# Example queries:

def number_of_vertices
  g.v.count
end

def number_of_edges
  g.e.count
end

# Perform a group_count on the "type" property
def summary_of_data_types
  g.v.group_count "type"
end

def percentage_of_enron_email_addresses
  num_enron_addresses = g.v(type: "Email Address").filter("address =~ /enron.com/").count
  num_all_addresses = g.v(type: "Email Address").count
  num_enron_addresses / num_all_addresses
end

def heavy_use_email_addresses
  g.v(type: "Email Address").filter{ |v| v.both_e.count >1000 }
end


