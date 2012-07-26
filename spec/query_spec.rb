require 'etsy/query'

describe Etsy::Query do
  specify do
    expect(Etsy::Query.new.to_s).to eq("/")
  end

  describe "a simple user query" do
    subject { Etsy::Query.new(:users) }
    its(:limit) { should eq(25) }
    its(:offset) { should eq(0) }
    its(:page) { should eq(1) }

    its(:to_s) { should eq('/users') }

    it "overrides limit" do
      subject.limit = 10
      expect(subject.limit).to eq(10)
      expect(subject.to_s).to eq('/users?limit=10')
    end

    it "overrides offset" do
      subject.offset = 3
      expect(subject.offset).to eq(3)
      expect(subject.to_s).to eq('/users?offset=3')
    end

    it "overrides page" do
      subject.page = 2
      expect(subject.page).to eq(2)
      expect(subject.to_s).to eq('/users?page=2')
    end

    it "selects specific fields" do
      subject.fields = %w(login_name user_id)
      expect(subject.to_s).to eq('/users?fields=login_name,user_id')
    end
  end

  describe "a specific user" do
    subject { Etsy::Query.new(:users, :key => 'cavetroll') }
    its(:to_s) { should eq('/users/cavetroll') }
  end

  describe "a user's stuff" do
    subject { Etsy::Query.new(:users, :key => 'cavetroll', :resource => :avatar) }
    its(:to_s) { should eq('/users/cavetroll/avatar') }
  end

  describe "a user's more specific stuff" do
    subject { Etsy::Query.new(:users, :key => 'cavetroll', :resource => [:avatar, :src]) }
    its(:to_s) { should eq('/users/cavetroll/avatar/src') }
  end
end
