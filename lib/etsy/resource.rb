module Etsy
  class Resource

    attr_reader :name, :limit, :offset, :fields, :scope, :child
    def initialize(name, options = {})
      @name = name.to_s.split('_').map(&:capitalize).join
      @limit = options[:limit]
      @offset = options[:offset]
      @fields = options[:fields] || []
      @scope = options[:scope]
    end

    def to_s
      "#{name}#{selected_fields}#{scoped}#{range}#{child_resource}"
    end

    def include(resource)
      @child = resource
      self
    end

    private

    def range
      return unless offset || limit

      if limit
        ":#{offset || 0}:#{limit}"
      else
        ":#{offset}"
      end
    end

    def selected_fields
      "(#{fields.join(',')})" unless fields.empty?
    end

    def scoped
      ":#{scope}" if scope
    end

    def child_resource
      "/#{child}" if child
    end

  end
end
