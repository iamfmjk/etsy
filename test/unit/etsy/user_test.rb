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

      should "be able to find the current logged in user" do
        oauth_keys = {:access_token => 'token', :access_secret => 'secret'}
        users = mock_request('/users/__SELF__', oauth_keys, 'User', 'getUser.single.json')
        User.myself('token', 'secret').should == users.first
      end
    end

    context "An instance of the User class" do

      context "with public response data" do
        setup do
          data = read_fixture('user/getUser.single.json')
          @user = User.new(data.first)
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

        should "not have an email address" do
          @user.email.should be_nil
        end
      end

      context "with private response data" do
        setup do
          data = read_fixture('user/getUser.single.private.json')
          @user = User.new(data.first)
        end

        should "have an email address" do
          @user.email.should == 'reaganpr@gmail.com'
        end
      end

      should "know when the user was created" do
        user = User.new
        user.stubs(:created).returns(1)

        user.created_at.should == Time.at(1)
      end
    end

    should "know the shop for a user" do
      user = User.new
      user.stubs(:username).with().returns('username')

      Shop.stubs(:find).with('username').returns('shop')

      user.shop.should == 'shop'
    end

  end
end
