module Cassia
  class Device
    include Virtus.model
    attribute :mac, String
    attribute :type, String
    attribute :bdaddrs
    attribute :chipId, Integer
    attribute :handle, String
    attribute :name, String
    attribute :connectionState, String
    attribute :id, String
  end
end
