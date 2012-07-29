require 'cgi'

module Etsy
  class Query

    attr_reader :resource, :options, :associations
    def initialize(*resource)
      @resource = resource.join('/')
      @options = {}
      @associations = []
    end

    def limit
      options.fetch(:limit) { 25 }
    end

    def offset
      options.fetch(:offset) { 0 }
    end

    def page
      options.fetch(:page) { 1 }
    end

    def include(resource)
      @associations << resource.to_s.split('_').map(&:capitalize).join
    end

    def endpoint
      "/#{resource}"
    end

    def query
      return {} if options.size == 0 && associations.empty?
      params = {}
      options.each do |k, v|
        params[k] = list(v)
      end
      unless associations.empty?
        params[:includes] = associations.join(',')
      end
      params
    end

    private

    def method_missing(method, *args, &block)
      if assignment?(method)
        key = method.to_s[0..-2].to_sym
        options[key] = args.length == 1 ? args.first : args
      elsif options.has_key?(method)
        options[method]
      else
        super
      end
    end

    def assignment?(method)
      # Depending on the version of Ruby,
      # s[-1] will return a character or a Fixnum
      method.to_s[-1] == '='[0]
    end

    def list(values)
      Array(values).join(',')
    end

  end
end
