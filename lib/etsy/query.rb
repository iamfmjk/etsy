require 'cgi'

module Etsy
  class Query

    attr_reader :resource, :key, :sub_resource, :options
    def initialize(resource = nil, options = {})
      @resource = resource.to_s
      @key = options.delete(:key)
      @sub_resource = options.delete(:resource)
      @options = options
    end

    def limit
      options.fetch(:limit) { 25 }
    end

    def limit=(value)
      options[:limit] = value
    end

    def offset
      options.fetch(:offset) { 0 }
    end

    def offset=(value)
      options[:offset] = value
    end

    def page
      options.fetch(:page) { 1 }
    end

    def page=(value)
      options[:page] = value
    end

    def fields=(values)
      options[:fields] = values
    end

    def endpoint
      ["", resource, key, sub_resource].compact.join("/")
    end

    def query
      return '' unless options.size > 0
      params = {}
      options.each do |k, v|
        params[k] = list(v)
      end
      params
    end

    private

    def list(values)
      Array(values).join(',')
    end

  end
end
