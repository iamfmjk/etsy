require 'spec_helper'
require 'etsy/query'

describe Etsy::Query do
  specify do
    expect(Etsy::Query.new.endpoint).to eq("/")
  end

  describe "a simple user query" do
    subject { Etsy::Query.new(:users) }
    its(:limit) { should eq(25) }
    its(:offset) { should eq(0) }
    its(:page) { should eq(1) }

    its(:endpoint) { should eq('/users') }

    it "overrides limit" do
      subject.limit = 10
      expect(subject.limit).to eq(10)
      expect(subject.query).to eq({:limit => '10'})
    end

    it "overrides offset" do
      subject.offset = 3
      expect(subject.offset).to eq(3)
      expect(subject.query).to eq({:offset => '3'})
    end

    it "overrides page" do
      subject.page = 2
      expect(subject.page).to eq(2)
      expect(subject.query).to eq({:page => '2'})
    end

    it "selects specific fields" do
      subject.fields = %w(login_name user_id)
      expect(subject.query).to eq({:fields => 'login_name,user_id'})
    end

    it "accepts arbitrary parameters" do
      subject.keywords = 'zombie+party'
      subject.keywords.should eq('zombie+party')
    end
  end

  describe "a specific user" do
    subject { Etsy::Query.new(:users, 'cavetroll') }
    its(:endpoint) { should eq('/users/cavetroll') }

    context "with associations" do

      it "takes resources" do
        subject.include(:addresses, :scope => :european)
        subject.include(:profile, :limit => 1, :offset => 2, :fields => [:picture, :name])
        expect(subject.query).to eq({:includes => 'Addresses:european,Profile(picture,name):2:1'})
      end

    end
  end

  describe "a user's stuff" do
    subject { Etsy::Query.new(:users, 'cavetroll', :avatar) }
    its(:endpoint) { should eq('/users/cavetroll/avatar') }
  end

  describe "a user's more specific stuff" do
    subject { Etsy::Query.new(:users, 'cavetroll', :avatar, :src) }
    its(:endpoint) { should eq('/users/cavetroll/avatar/src') }
  end

end
