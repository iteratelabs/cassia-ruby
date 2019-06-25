module Cassia
  class Router
    include Virtus.model
    attribute :_id, String
    attribute :id, String
    attribute :mac, String
    attribute :name, String
    attribute :group, String
    attribute :status, String
    attribute :model, String
    attribute :version, String
    attribute :position, String
    attribute :time, Integer
    attribute :ip, String
    attribute :localip, String
    attribute :uptime, Integer
    attribute :offline_time, Integer
    attribute :online_time, Integer
    attribute :update_status, String
    attribute :update_reason, String
    attribute :update_version, String
    attribute :update_progress, Integer
    attribute :container, Hash
    attribute :ap, Hash
  end
end
