# http://sneaq.net/textmate-wtf
$:.reject! { |e| e.include? 'TextMate' }

require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'matchy'
require 'mocha'

require File.expand_path('../../lib/etsy', __FILE__)

class Test::Unit::TestCase


  def raw_fixture_data(filename)
    file = File.dirname(__FILE__) + "/fixtures/#{filename}"
    File.read(file)
  end

  def read_fixture(filename)
    JSON.parse(raw_fixture_data(filename))['results']
  end

  def mock_request(endpoint, options, resource, file)
    objects       = []
    response_data = raw_fixture_data("#{resource.downcase}/#{file}")

    Etsy::Request.stubs(:new).with(endpoint, options).returns(stub(:get => stub(:body => response_data)))

    JSON.parse(response_data)['results'].each_with_index do |result, index|
      object = "#{resource.downcase}_#{index}"
      Etsy.const_get(resource).stubs(:new).with(result).returns(object)
      objects << object
    end

    objects
  end

end
