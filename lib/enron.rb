require 'pathname'
require 'pacer'


module Pacer
  module Examples
    class Enron

      DEFAULT_DATA_PATH = Pathname.new(__FILE__).parent.parent + "db/enron_data.graphml"

      attr_accessor :graph
      alias :g :graph

      class << self
        # Load enron GraphML file and return new Enron example class
        def load_data(path = DEFAULT_DATA_PATH)
          tg = Pacer.tg
          puts "Loading graph in '#{path}' into new TinkerGraph"
          start_time = Time.now
          Pacer::GraphML.import tg, path
          puts "Data loaded in #{Time.now - start_time} secs"
          new tg
        end

        def reload!
          load __FILE__
        end
      end

      def initialize(graph = nil)
        self.graph = graph if graph
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

    end
  end
end

