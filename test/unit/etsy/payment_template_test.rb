require File.expand_path('../../../test_helper', __FILE__)

module Etsy
  class PaymentTemplateTest < Test::Unit::TestCase
    context "An instance of the PaymentTemplate class" do
      setup do
        data = read_fixture('payment_template/getPaymentTemplate.json')
        @payment_template = PaymentTemplate.new(data.first)
      end

      should "have an id" do
        @payment_template.id.should == 51
      end

      should "have attribute: allow_check" do
        @payment_template.allow_check.should == false
      end

      should "have attribute: allow_mo" do
        @payment_template.allow_mo.should == false
      end

      should "have attribute: allow_other" do
        @payment_template.allow_other.should == true
      end

      should "have attribute: allow_paypal" do
        @payment_template.allow_paypal.should == true
      end

      should "have attribute: allow_cc" do
        @payment_template.allow_cc.should == false
      end

      should "have attribute: paypal_email" do
        @payment_template.paypal_email.should == "user@example.com"
      end

      should "have attribute: name" do
        @payment_template.name.should == "Example Template"
      end

      should "have attribute: first_line" do
        @payment_template.first_line.should == nil
      end

      should "have attribute: second_line" do
        @payment_template.second_line.should == nil
      end

      should "have attribute: city" do
        @payment_template.city.should == "Chicago"
      end

      should "have attribute: state" do
        @payment_template.state.should == "IL"
      end

      should "have attribute: zip" do
        @payment_template.zip.should == "60605"
      end

      should "have attribute: country_id" do
        @payment_template.country_id.should == 4
      end
    end
  end
end
