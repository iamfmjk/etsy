require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class BillingOverviewTest < Test::Unit::TestCase
    context "An instance of the BillingOverview class" do
      setup do
        data = read_fixture('billing_overview/getBillingOverview.json')
        @billing_overview = BillingOverview.new(data.first)
      end

      should "have a total_balance" do
        @billing_overview.total_balance.should == 1399
      end

      should "have a balance_due" do
        @billing_overview.balance_due.should == 999
      end
    end
  end
end
