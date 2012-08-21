module Etsy
  class Resource

    attr_reader :name, :limit, :offset, :fields, :scope
    def initialize(name, options = {})
      @name = name.to_s.split('_').map(&:capitalize).join
      @limit = options[:limit]
      @offset = options[:offset]
      @fields = options[:fields] || []
      @scope = options[:scope]
    end

    def range
      return unless offset || limit

      if limit
        ":#{offset || 0}:#{limit}"
      else
        ":#{offset}"
      end
    end

    def selected_fields
      fields.empty? ? '' : "(#{fields.join(',')})"
    end

    def scoped
      return ":#{scope}" if scope
    end

    def to_s
      "#{name}#{selected_fields}#{scoped}#{range}"
    end
  end
end
