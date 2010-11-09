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

    def initialize(result = nil)
      @result = result
    end

    def self.included(other)
      other.extend ClassMethods
    end

  end
end