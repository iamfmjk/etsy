require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class ProfileTest < Test::Unit::TestCase

    # The Etsy profile can only be accessed as an association through other resources.
    # There are no finders.
    context "An instance of the Profile class" do

      context "with response data" do
        setup do
          data = read_fixture('profile/new.json')
          @profile = Profile.new(data)
        end

        should "have a value for :id" do
          @profile.id.should == 123
        end

        should "have a value for :user_id" do
          @profile.user_id.should == 5327518
        end

        should "have a value for :username" do
          @profile.username.should == "littletjane"
        end

        should "have a value for :bio" do
          @profile.bio.should == "I make stuff"
        end

        should "have a value for :gender" do
          @profile.gender.should == "female"
        end

        should "have a value for :birth_day" do
          @profile.birth_day.should == "01"
        end

        should "have a value for :birth_month" do
          @profile.birth_month.should == "01"
        end

        should "have a value for :birth_year" do
          @profile.birth_year.should == "1970"
        end

        should "have a value for :joined_at" do
          @profile.joined_at.should == Time.at(1225392413)
        end

        should "have a value for :materials" do
          @profile.materials.should == []
        end

        should "have a value for :country_id" do
          @profile.country_id.should == 209
        end

        should "have a value for :city" do
          @profile.city.should == "BigCity"
        end

        should "have a value for :avatar_id" do
          @profile.avatar_id.should == 345
        end

        should "have a value for :location" do
          @profile.location.should == "HQ"
        end

        should "have a value for :region" do
          @profile.region.should == "The Desert"
        end

        should "have a value for :lat" do
          @profile.lat.should == 39.5304
        end

        should "have a value for :lon" do
          @profile.lon.should == -119.8144
        end

        should "have a value for :transaction_buy_count" do
          @profile.transaction_buy_count.should == 19
        end

        should "have a value for :transaction_sold_count" do
          @profile.transaction_sold_count.should == 16
        end

        should "have a value for :seller?" do
          @profile.seller?.should == true
        end

        should "have a value for :image" do
          @profile.image.should == 'some_image.jpg'
        end

        should "have a value for :first_name" do
          @profile.first_name.should == 'Tinker'
        end

        should "have a value for :last_name" do
          @profile.last_name.should == 'Bell'
        end
      end

    end
  end
end
