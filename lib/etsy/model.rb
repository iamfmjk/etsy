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

      def get(endpoint, options = {})
        objects = get_all(endpoint, options)
        (objects.length == 1) ? objects[0] : objects
      end

      def get_all(endpoint, options={})
        response = Request.get(endpoint, options)
        [response.result].flatten.map { |data| new(data) }
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
