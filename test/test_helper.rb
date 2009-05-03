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
  
  def mock_request_cycle(options)
    response = Etsy::Response.new(stub())
    
    data = read_fixture(options[:data])
    data = data.first if data.size == 1
    
    response.stubs(:result).with().returns(data)
    
    Etsy::Request.stubs(:get).with(options[:for]).returns(response)
    
    response
  end
  
  def self.when_populating(klass, options, &block)
    class_eval <<-CODE
      def setup_for_population
        @object = #{klass}.new(read_fixture('#{options[:from]}')[0])
      end
    CODE
    
    block.call
  end

  def self.value_for(method_name, options)
    class_eval do
      it "should have a value for :#{method_name}" do
        setup_for_population
        @object.send(method_name).should == options[:is]
      end
    end
  end
  
end