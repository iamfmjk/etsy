module Etsy
  module Model # :nodoc:all

    module ClassMethods

      def attribute(name, options = {})
        define_method name do
          @result[options.fetch(:from, name).to_s]
        end
      end

      def attributes(*names)
        names.each {|name| attribute(name) }
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