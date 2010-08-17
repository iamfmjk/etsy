require File.dirname(__FILE__) + '/../../test_helper'

module Etsy
  class UserTest < Test::Unit::TestCase

    context "The User class" do

      should "be able to find a single user" do
        raw_data = raw_fixture_data('user/getUser.single.json')

        request = stub(:get => raw_data)
        Request.stubs(:new).with('/users/littletjane', {}).returns(request)

        user_data = JSON.parse(raw_data)['results'][0]
        User.expects(:new).with(user_data).returns('user')

        User.find('littletjane').should == 'user'
      end

      should "be able to find multiple users" do
        raw_data = raw_fixture_data('user/getUser.multiple.json')
        request = stub(:get => raw_data)
        Request.stubs(:new).with('/users/littletjane,reagent', {}).returns(request)

        user_data_1 = JSON.parse(raw_data)['results'][0]
        User.expects(:new).with(user_data_1).returns('user_1')

        user_data_2 = JSON.parse(raw_data)['results'][1]
        User.expects(:new).with(user_data_2).returns('user_2')

        User.find('littletjane', 'reagent').should == ['user_1', 'user_2']
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