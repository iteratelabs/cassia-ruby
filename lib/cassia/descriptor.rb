module Cassia
  class Descriptor
    include Virtus.model
    attribute :uuid, String
    attribute :handle, Integer

    def ==(other)
      return self.uuid == other.uuid && self.handle == other.handle
    end
  end
end
