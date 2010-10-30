require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class UserTest < Test::Unit::TestCase

    context "The User class" do

      should "be able to find a single user" do
        users = mock_request('/users/littletjane', {}, 'User', 'getUser.single.json')
        User.find('littletjane').should == users.first
      end

      should "be able to find multiple users" do
        users = mock_request('/users/littletjane,reagent', {}, 'User', 'getUser.multiple.json')
        User.find('littletjane', 'reagent').should == users
      end

    end

    context "An instance of the User class" do

      context "with response data" do
        setup do
          raw = raw_fixture_data('user/getUser.single.json')
          data = JSON.parse(raw)['results'][0]

          @user = User.new(data)
        end

        should "have an ID" do
          @user.id.should == 5327518
        end

        should "have a :username" do
          @user.username.should == 'littletjane'
        end

        should "have a value for :created" do
          @user.created.should == 1191381578
        end
      end

      should "know when the user was created" do
        user = User.new
        user.stubs(:created).returns(1)

        user.created_at.should == Time.at(1)
      end

    end

  end
end