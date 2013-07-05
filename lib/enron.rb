require 'pathname'
require 'rubygems'
unless require 'pacer'
  puts "Missing dependencies: pacer pacer-neo4j"
end
unless require 'pacer-neo4j'
  puts "Missing dependency: pacer-neo4j"
end

class Enron

  DATA_PATH = Pathname.new(__FILE__).parent.parent + "db/enron_data.graphml"

  attr_accessor :g

  class << self
    # Load enron GraphML file and return new Enron example class
    def load_data(g = nil, path = DATA_PATH)
      g ||= Pacer.neo4j 'db/enron.graph'
      g.create_key_index :type
      puts "Loading data in '#{path}' into new graph."
      puts "This will take several minutes."
      start_time = Time.now
      Pacer::GraphML.import g, path
      puts "Data loaded in #{Time.now - start_time} secs"
      new g
    end

    def reload!
      load __FILE__
    end
  end

  def initialize(graph = nil)
    if graph.is_a? String
      self.g = Pacer.neo4j graph
    else
      self.g = graph
    end
  end

  ##################
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

  # Helper method which both takes a route and returns a route
  # This route-chaining is a big part of what makes Pacer so powerful.
  def email_addresses(route = g)
    route.v(type: "Email Address")
  end

  def messages(route = g)
    route.v(type: "Message")
  end

  # This is a route to all Person vertices.
  # These are the people of interest from the Org. Chart
  def people(route = g)
    route.v(type: "Person")
  end

  def enron_email_addresses(route = g)
    email_addresses(route).filter{ |v| v["address"] =~ /enron.com/ }
  end


  # Simple property filters with route chaining and a regex, to find the
  # percentage of internal emailers.
  def percentage_of_enron_email_addresses(route = g)
     enron_email_addresses(route).count / email_addresses(route).count.to_f
  end

  # Example of a lookahead to find heavy e-mailers
  def heavy_use_email_addresses(route = g)
    email_addresses(route).lookahead(min: 1000){ |v| v.both_e }
  end

  def saucy_messages(route = g)
    messages(route).filter{ |v| v["body"] =~ /slept with|sex|lover|spoon/ }
  end

  def saucy_messages_from_enron_email(route = g)
    saucy_messages(route).lookahead { |v| enron_email_addresses(v.in_e('SENT').out_v) }
  end

  # Only people of interest are represented in the graph as 'Person' nodes.
  # This method uses a lookahead with route chaining to return a route of
  # saucy messages which are only *from* these people of interest
  #
  def saucy_messages_from_enron_people(route = g)
    saucy_messages(route).lookahead { |msg_v| people( msg_v.in('SENT').in('USED_EMAIL_ADDRESS') ) }
  end

  def percentage_of_saucy_messages_from_enron_people(route = g)
    saucy_messages_from_enron_people.count / saucy_messages.count.to_f
  end

  def price_fixing_messages(route = g)
    messages(route).filter{ |v| v["body"] =~ /price fix|agree on price/ }
  end

end

