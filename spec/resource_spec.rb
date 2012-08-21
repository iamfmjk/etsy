require 'etsy/resource'

describe Etsy::Resource do

  it "takes a resource" do
    Etsy::Resource.new(:knives).to_s.should eq('Knives')
  end

  it "takes multi-word resources" do
    Etsy::Resource.new(:oven_mitts).to_s.should eq('OvenMitts')
  end

  it "specifies offset" do
    Etsy::Resource.new(:drain, :offset => 3).to_s.should eq('Drain:3')
  end

  it "specifies limit" do
    Etsy::Resource.new(:drain, :limit => 4).to_s.should eq('Drain:0:4')
  end

  it "handles a full range" do
    Etsy::Resource.new(:dish_soap, :offset => 1, :limit => 7).to_s.should eq('DishSoap:1:7')
  end

  it "specifies fields" do
    Etsy::Resource.new(:fridge, :fields => [:cheese, :milk]).to_s.should eq('Fridge(cheese,milk)')
  end

  it "takes a scope" do
    Etsy::Resource.new(:pantry, :scope => :stale).to_s.should eq('Pantry:stale')
  end

  it "does it all" do
    options = {
      :limit => 42,
      :offset => 1337,
      :fields => [:water, :soap],
      :scope => :dirty
    }
    Etsy::Resource.new(:kitchen_sink, options).to_s.should eq('KitchenSink(water,soap):dirty:1337:42')
  end

end
