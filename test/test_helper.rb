# http://sneaq.net/textmate-wtf
$:.reject! { |e| e.include? 'TextMate' }

require 'rubygems'
require 'throat_punch'

require File.dirname(__FILE__) + '/../lib/etsy'

class Test::Unit::TestCase
  
  def read_fixture(method_name)
    file = File.dirname(__FILE__) + "/fixtures/#{method_name}.json"
    JSON.parse(File.read(file))['results']
  end
  
  def self.value_for(method_name, options)
    @@tests ||= []
    
    value = options[:is]
    value = "'#{value}'" if value.kind_of?(String)
    
    test = <<-EOF
      it "should have a value for :#{method_name}" do        
        @object.send(:#{method_name}).should == #{value}
      end
    EOF
    
    @@tests << test
  end

  def self.when_populating(klass, options, &block)
    
    context "when populating data for #{klass} from the #{options[:from]} call" do
      before do
        @object = klass.new(read_fixture(options[:from]))
      end

      block.call
      
      class_eval @@tests.join("\n")
      
    end
    
  end
  
end