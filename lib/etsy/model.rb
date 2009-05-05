module Etsy
  module Model # :nodoc:all
    
    module ClassMethods
      
      def attribute(name, options = {})
        from = options.fetch(:from, name)

        class_eval <<-CODE
          def #{name}
            @result['#{from}']
          end
        CODE
      end
      
      def attributes(*names)
        names.each {|name| attribute(name) }
      end

      def finder(type, endpoint)
        parameter = endpoint.scan(/:\w+/).first
        parameter.sub!(/^:/, '')

        endpoint.sub!(":#{parameter}", '#{' + parameter + '}')

        send("find_#{type}", parameter, endpoint)
      end
      
      def find_all(parameter, endpoint)
        class_eval <<-CODE
          def self.find_all_by_#{parameter}(#{parameter})
            response = Request.get("#{endpoint}")
            response.result.map {|listing| new(listing) }
          end
        CODE
      end
      
      def find_one(parameter, endpoint)
        class_eval <<-CODE
          def self.find_by_#{parameter}(#{parameter})
            response = Request.get("#{endpoint}")
            new response.result
          end
        CODE
      end
      
    end
    
    module InstanceMethods
      
      def initialize(result = nil)
        @result = result
      end
      
    end
    
    def self.included(other)
      other.send(:extend, Etsy::Model::ClassMethods)
      other.send(:include, Etsy::Model::InstanceMethods)
    end
    
    
  end
end