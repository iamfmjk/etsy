require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class TransactionTest < Test::Unit::TestCase

    context "The Transaction class" do

      should "be able to find transactions for a shop" do
        transactions = mock_request('/shops/1/transactions', {'key' => 'value'}, 'Transaction', 'findAllShopTransactions.json')
        Transaction.find_all_by_shop_id(1, {'key' => 'value'}).should == transactions
      end

    end

    context "An instance of the Transaction class" do

      context "with response data" do
        setup do
          data = read_fixture('transaction/findAllShopTransactions.json')
          @transaction = Transaction.new(data.first)
        end

        should "have a value for :id" do
          @transaction.id.should == 27230877
        end

        should "have a value for :quantity" do
          @transaction.quantity.should == 1
        end

        should "have a value for :buyer_id" do
          @transaction.buyer_id.should == 9641557
        end

        should "have a value for :listing_id" do
          @transaction.listing_id.should == 41680579
        end
      end

      should "know the buyer" do
        User.stubs(:find).with(1).returns('user')

        transaction = Transaction.new
        transaction.stubs(:buyer_id).with().returns(1)

        transaction.buyer.should == 'user'
      end

    end

  end
end