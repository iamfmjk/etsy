require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class TestModel
    include Etsy::Model
  end

  class ModelTest < Test::Unit::TestCase
    context 'An instance of a Model' do
      def mock_empty_request(options = {})
        Request.expects(:new).with('', options).returns(stub(:get => stub(:body => '{}')))
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
    end
  end
end
