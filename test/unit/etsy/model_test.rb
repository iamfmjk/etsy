require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class TestModel
    include Etsy::Model
  end

  class ModelTest < Test::Unit::TestCase
    context 'An instance of a Model' do
      def mock_empty_request(options = {})
        body = options.delete(:body) { '{}' }
        Request.expects(:new).with('', options).returns(stub(:get => stub(:body => body)))
      end

      should 'perform no requests if :limit is 0' do
        Request.expects(:new).never
        TestModel.get_all('', :limit => 0)
      end

      should 'perform only one request if :limit is less than 100' do
        mock_empty_request(:limit => 10, :offset => 0).once
        TestModel.get_all('', :limit => 10)
      end

      should 'perform only one request if :limit is equal to 100' do
        mock_empty_request(:limit => 100, :offset => 0).once
        TestModel.get_all('', :limit => 100)
      end

      should 'perform multiple requests if :limit is greater than 100' do
        mock_empty_request(:limit => 100, :offset => 0).once
        mock_empty_request(:limit => 50, :offset => 100).once

        TestModel.get_all('', :limit => 150)
      end

      should 'perform only one request if :limit is :all and count is less than 100' do
        mock_empty_request(:limit => 100, :offset => 0, :body => '{"count": 10}').once
        TestModel.get_all('', :limit => :all)
      end

      should 'perform only one request if :limit is :all and count is equal to 100' do
        mock_empty_request(:limit => 100, :offset => 0, :body => '{"count": 100}').once
        TestModel.get_all('', :limit => :all)
      end

      should 'perform only one request if :limit is :all and :offset is greater than count' do
        mock_empty_request(:limit => 100, :offset => 40, :body => '{"count": 25}').once
        TestModel.get_all('', :limit => :all, :offset => 40)
      end

      should 'perform multiple requests if :limit is :all and count is greater than 100' do
        body = '{"count": 210}'
        mock_empty_request(:limit => 100, :offset => 0, :body => body).once
        mock_empty_request(:limit => 100, :offset => 100, :body => body).once
        mock_empty_request(:limit => 10, :offset => 200, :body => body).once

        TestModel.get_all('', :limit => :all)
      end
    end
  end
end
