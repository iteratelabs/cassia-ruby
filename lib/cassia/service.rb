module Cassia
  class Service
    include Virtus.model
    attribute :uuid, String
    attribute :primary, Boolean
    attribute :handle, Integer
    attribute :characteristics, Array[Cassia::Characteristic]

    def ==(other)
      return self.uuid == other.uuid && self.primary == other.primary && self.handle == other.handle && self.characteristics == other.characteristics
    end
  end
end
