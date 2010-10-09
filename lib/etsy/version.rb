module Etsy
  module Version
    
    MAJOR = 0
    MINOR = 1
    TINY  = 1
    
    def self.to_s # :nodoc:
      [MAJOR, MINOR, TINY].join('.')
    end
    
  end
end
