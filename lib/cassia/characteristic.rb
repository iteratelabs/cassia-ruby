module Cassia
  class Characteristic
    include Virtus.model
    attribute :uuid, String
    attribute :properties, Integer
    attribute :handle, Integer
    attribute :descriptors, Array

    def ==(other)
      return self.uuid == other.uuid && self.properties == other.properties && self.handle == other.handle && self.descriptors == other.descriptors
    end
  end
end
