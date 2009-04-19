module Etsy
  module Model
    
    module ClassMethods
      
      def attribute(name, options = {})
        from = options.fetch(:from, name)

        class_eval <<-CODE
          def #{name}
            @result['#{from}']
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