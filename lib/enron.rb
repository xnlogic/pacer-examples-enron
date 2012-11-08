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
  end
end

