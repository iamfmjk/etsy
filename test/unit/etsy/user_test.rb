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

      should "be able to pass options when finding a user" do
        options = {:limit => 90, :offset => 90}
        users = mock_request('/users/littletjane', options, 'User', 'getUser.single.json')
        User.find('littletjane', options).should == users.first
      end

      should "be able to find the authenticated user" do
        options = {:access_token => 'token', :access_secret => 'secret'}
        users = mock_request('/users/__SELF__', options, 'User', 'getUser.single.json')
        User.myself('token', 'secret', options).should == users.first
      end
    end

    context "An instance of the User class" do

      context "requested with oauth access token" do
        setup do
          options = {:access_token => 'token', :access_secret => 'secret'}

          data = read_fixture('user/getUser.single.json')
          response = 'response'
          response.stubs(:result).with().returns [data]
          Request.stubs(:get).with('/users/__SELF__', options).returns response

          @user = User.find('__SELF__', options)
        end

        should "persist the token" do
          @user.token.should == 'token'
        end

        should "persist the secret" do
          @user.secret.should == 'secret'
        end
      end

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
          @user = User.new(data.first, 'token', 'secret')
        end

        should "have an email address" do
          @user.email.should == 'reaganpr@gmail.com'
        end

      end

      context "requested with an associated profile" do
        setup do
          data = read_fixture('user/getUser.single.withProfile.json')
          @user = User.new(data.first)
        end

        should "have a profile" do
          @user.profile.class.should == Profile
        end
      end

      context "requested without an associated profile" do
        setup do
          @data_without_profile = read_fixture('user/getUser.single.json')
          @data_with_profile = read_fixture('user/getUser.single.withProfile.json')
          @options = {:fields => 'user_id', :includes => 'Profile'}

          @user_without_profile = User.new(@data_without_profile.first)
          @user_with_profile = User.new(@data_with_profile.first)
        end

        should "make a call to the API to retrieve it if requested" do
          User.expects(:find).with('littletjane', @options).returns @user_with_profile
          @user_without_profile.profile
        end

        should "not call the api twice" do
          User.expects(:find).once.with('littletjane', @options).returns @user_with_profile
          @user_without_profile.profile
          @user_without_profile.profile
        end

        should "return a populated profile instance" do
          User.stubs(:find).with('littletjane', @options).returns @user_with_profile
          @user_without_profile.profile.bio.should == 'I make stuff'
        end

        should "make the call with authentication if oauth is used" do
          user = User.new(@data_without_profile.first, 'token', 'secret')
          oauth = {:access_token => 'token', :access_secret => 'secret'}
          User.expects(:find).with('littletjane', @options.merge(oauth)).returns @user_with_profile
          user.profile
        end
      end

      context "instantiated with oauth token" do
        setup do
          @user = User.new(nil, 'token', 'secret')
        end

        should "have the token" do
          @user.token.should == 'token'
        end

        should "have the secret" do
          @user.secret.should == 'secret'
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

      Shop.stubs(:find).with('username', {}).returns('shop')

      user.shop.should == 'shop'
    end

  end
end
