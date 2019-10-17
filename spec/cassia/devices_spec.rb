require 'spec_helper'

RSpec.describe Cassia::Device do
  describe "#==" do
    it "returns true for two matching routers by mac" do
      router1 = described_class.new(mac: '1', )
      router2 = described_class.new(mac: '1')

      expect(router1==router2).to be_truthy
    end

    it "returns false for two routers with differnet macs" do
      router1 = described_class.new(mac: '1')
      router2 = described_class.new(mac: '2')

      expect(router1==router2).to be_falsey
    end
  end

  describe "#eql?" do
    it "returns true for two matching routers by mac" do
      router1 = described_class.new(mac: '1')
      router2 = described_class.new(mac: '1')

      expect(router1==router2).to be_truthy
    end

    it "returns false for two routers with differnet macs" do
      router1 = described_class.new(mac: '1')
      router2 = described_class.new(mac: '2')

      expect(router1==router2).to be_falsey
    end
  end
end
