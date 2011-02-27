require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class AddressTest < Test::Unit::TestCase

    context "The Address class" do

      should "be able to find a user's addresses" do
        addresses = mock_request('/users/littletjane/addresses', {}, 'Address', 'getUserAddresses.json')
        Address.find('littletjane').should == addresses
      end

    end

    context "An instance of the Address class" do

      context "with response data" do
        setup do
          data = read_fixture('address/getUserAddresses.json')
          @address = Address.new(data.first)
        end

        should "have a value for :id" do
          @address.id.should == 123
        end

        should "have a value for :name" do
          @address.name.should == "Tinker Bell"
        end

        should "have a value for :first_line" do
          @address.first_line.should == "123 Fake St."
        end

        should "have a value for :second_line" do
          @address.second_line.should == nil
        end

        should "have a value for :city" do
          @address.city.should == 'BigCity'
        end

        should "have a value for :state" do
          @address.state.should == 'XX'
        end

        should "have a value for :zip" do
          @address.zip.should == '12345'
        end

        should "have a value for :country" do
          @address.country.should == 'United States'
        end

        should "have a value for :country_id" do
          @address.country_id.should == 209
        end
      end
    end
  end
end
