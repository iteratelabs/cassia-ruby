[![Maintainability](https://api.codeclimate.com/v1/badges/dd4bf18bcdf6b2bdc860/maintainability)](https://codeclimate.com/github/iteratelabs/cassia-ruby/maintainability) [![CircleCI](https://circleci.com/gh/iteratelabs/cassia-ruby/tree/master.svg?style=svg)](https://circleci.com/gh/iteratelabs/cassia-ruby/tree/master)
# Cassia::Ruby

This gem was created in order to allow Ruby developers to interact with the Cassia Bluetooth Gateway API's https://www.cassianetworks.com/download/docs/Cassia_SDK_Implementation_Guide.pdf.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cassia-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cassia-ruby

## Configuration
Here is a list of the available configuration options and their default values

| Option          | Description                       | Optional|
|-----------------|:---------------------------------:|---------|
| `ac_url`        | The URL of your AC server address | No      |
| `client_id`     | Your Cassia API Developer Key     | No      |
| `secret`        | Your Cassia API Developer Secret  | No      |
| `client_cert`   | Your SSL client cert              | Yes     |
| `client_key`    | Your SSL client key               | Yes     |
| `ca_file`       | Your SSL CA file                  | Yes     |

### Setting your configuration

To set configuration options use the `Cassia.configure` method:

```ruby
Cassia.configure do |config|
  config.ac_url = ENV['CASSIA_AC_URL']
  config.client_id = ENV['CASSIA_CLIENT_ID']
  config.secret = ENV['CASSIA_SECRET']
end
```

## Resources

### AccessControllers

In the following context, `access_controller` is a `Cassia::AccessController` object which contains attributes and structures of a Cassia access controller.

#### Retrieve An Access Token From the Cassia API
```ruby
access_controller.get_token
access_controller.access_token
```

`get_token` will make a request from `access_controller` to generate an access token encoded from `config.client_id` and `config.secret` using base64.

`access_token` will return the access token of `access_controller`.

#### Obtain Cassia router's status
```ruby
access_controller.get_all_routers_status
access_controller.routers
```

`routers` will return an Array of `Router` objects connected to `access_controller`.

#### Switch Router Auto-Selection
```ruby
access_controller.switch_autoselect(flag: 1)
```

If `flag` is 1, the router auto-selection function will be enabled. If `flag` is 0, the router auto-selection function will be disabled.

#### Open Scanning for all the routers in the router list
```ruby
access_controller.open_scan(aps: ["CC:1B:E0:E7:FE:F8",  "CC:1B:E0:E7:FE:F8", "CC:1B:E0:E7:FE:F8"], chip: 0, active: 0, filter_name: "cassia", filter_mac: "CC:1B:E0:E7:FE:F7", filter_uuid: "00001800-0000-1000-800000805f9b34fb")
```

`aps` is an array of one or multiple router's MAC address.
`chip` (optional) means which chip to scan.
`active` (optional) is either 0 or 1. 0 means enable passive scanning, 1 means enable active scanning.
`filter_name` (optional) is a filter for device name.
`filter_mac` (optional) is a filter for device MAC.
`filter_uuid` (optional) is a filter for device UUID.

#### Close Scanning for all the routers in the router list
```ruby
access_controller.close_scan(aps: ["CC:1B:E0:E7:FE:F8",  "CC:1B:E0:E7:FE:F8", "CC:1B:E0:E7:FE:F8"])
```

`aps` is an array of one or multiple router's MAC address.

#### Connect A Device to An Automatically Selected Router from the router list
```ruby
access_controller.connect_device(aps: '*', device_mac: "CC:1B:E0:E7:FE:F8")
```

`aps` is an array of one or multiple router's MAC address, or the string '*' which refers to all currently connected routers.
`device_mac` is the mac address of the device that you are connecting to. You may only pass in one MAC address.

#### Disconnect A Device
```ruby
access_controller.disconnect_device(device_mac: "CC:1B:E0:E7:FE:F8")
```

`device_mac` is the mac address of the device that you are disconnecting.

#### Open Notification on SSE Channel
```ruby
access_controller.open_notify(aps:  ["CC:1B:E0:E7:FE:F8","CC:1B:E0:E7:FE:F8"])
```

`aps` is an array of one or multiple router's MAC address.

#### Close Notification on SSE Channel
```ruby
access_controller.close_notify(aps: ["CC:1B:E0:E7:FE:F8","CC:1B:E0:E7:FE:F8"])
```

`aps` is an array of one or multiple router's MAC address.

#### Open Connection-state Monitoring on SSE Channel
```ruby
access_controller.open_connection_state(aps: ["CC:1B:E0:E7:FE:F8","CC:1B:E0:E7:FE:F8"])
```

`aps` is an array of one or multiple router's MAC address.

#### Close Connection-state Monitoring on SSE Channel
```ruby
access_controller.close_connection_state(aps: ["CC:1B:E0:E7:FE:F8","CC:1B:E0:E7:FE:F9"])
```

`aps` is an array of one or multiple router's MAC address.

#### Open Ap-state Monitoring on SSE Channel
```ruby
access_controller.open_ap_state
```

#### Close Ap-state Monitoring on SSE Channel
```ruby
access_controller.close_ap_state
```

#### Create One Combined SSE Connection
```ruby
access_controller.combined_sse do |client|
  client.on_event do |event|
    puts "I received an event: #{event.type}, #{event.data}"
   # put code here to act on events
  end
  client.on_error { |err| puts "#{err.status}" }
end
```
You can pass a block to the combined_sse method that allows you to act on the SSE's that you get from the routers.

We are using the https://github.com/launchdarkly/ruby-eventsource gem ld-eventsource for our SSE client. Please refer to their documentation for more info.

#### Discover All GATT Services
```ruby
access_controller.discover_all_services(router: "CC:1B:E0:E7:FE:F8", device_mac: "CC:1B:E0:E7:FE:F9")
device.services
```

`router` is the MAC address of the router that is currently connected to the access controller.

`device_mac` is the mac address of the device that you are discovering all GATT services of.

`device` is an `Cassia::Device` object with mac address `device_mac`. `device.services` returns all GATT services provided by `device`.

#### Discover All GATT Characteristics
```ruby
access_controller.discover_all_char(router: "CC:1B:E0:E7:FE:F8", device_mac: "CC:1B:E0:E7:FE:F9")
device.characteristics
```

`router` is the MAC address of the router that is currently connected to the access controller.

`device_mac` is the mac address of the device that you are discovering all GATT characteristics of.

`device` is an `Cassia::Device` object with mac address `device_mac`. `device.characteristics` returns all GATT characteristics of services provided by `device`.

#### Discover All Characteristics of One Service
```ruby
access_controller.discover_all_char(router: "CC:1B:E0:E7:FE:F8", device_mac: "CC:1B:E0:E7:FE:F9", service_uuid: "00001800-0000-1000-800000805f9b34fb")
service.characteristics
```

`router` is the MAC address of the router that is currently connected to the access controller.

`device_mac` is the mac address of the device that you are discovering GATT characteristics of.

`servide_uuid` is the uuid of the service that you are discovering GATT characteristics of.

`service` is an `Cassia::Service` object with uuid `service_uuid`. `service.characteristics` returns all GATT characteristics of `service`.

#### Discover All Characteristics And Services
```ruby
access_controller.discover_all_services_and_chars(router: "CC:1B:E0:E7:FE:F8", device_mac: "CC:1B:E0:E7:FE:F9")
device.services
device.characteristics
```

`router` is the MAC address of the router that is currently connected to the access controller.

`device_mac` is the mac address of the device that you are discovering GATT characteristics and services of.

`device` is an `Cassia::Device` object with mac address `device_mac`. `device.services` returns all GATT services provided by `device`.
`device.characteristics` returns all GATT characteristics of services provided by `device`.

#### Write Value Of A Characteristic
```ruby
access_controller.write_char_by_handle(router: "CC:1B:E0:E7:FE:F8", device_mac: "CC:1B:E0:E7:FE:F9", handle: 3, value: "0100")
```

`router` is the MAC address of the router that is currently connected to the access controller.

`device_mac` is the mac address of the device that you are writing GATT characteristic to.

`handle` is the handle of the characteristic that you are writing.

`value` refers to the function you would like executed. To open the notification, set `value` to "0100". To close the notification, set `value` to "0000".

#### Open Notification of A Characteristic
```ruby
access_controller.open_char_notification(router: "CC:1B:E0:E7:FE:F8", device_mac: "CC:1B:E0:E7:FE:F9", handle: 3)
```

`router` is the MAC address of the router that is currently connected to the access controller.

`device_mac` is the mac address of the device whose characteristic is being turned on notification.

`handle` is the handle of the characteristic that you are turning notification on.

#### Close Notification of A Characteristic
```ruby
access_controller.close_char_notification(router: "CC:1B:E0:E7:FE:F8", device_mac: "CC:1B:E0:E7:FE:F9", handle: 3)
```

`router` is the MAC address of the router that is currently connected to the access controller.

`device_mac` is the mac address of the device whose characteristic is being turned off notification.

`handle` is the handle of the characteristic that you are turning notification off.

### Routers

In the following context, `router` is a `Cassia::Router` object which contains attributes and structures of a router.

#### Connect To A Target Device
```ruby
router.connect_local(access_controller, device_mac: "CC:1B:E0:E7:FE:F9", type: "random")
```

`device_mac` is the mac address of the device that you are connecting `router` to.

`type` is the address type of the device, either "public" or "random".

#### Disconnect A Target Device
```ruby
router.disconnect_local(access_controller, device_mac: "CC:1B:E0:E7:FE:F9")
```

`device_mac` is the mac address of the device that you are disconnecting from `router`.

#### Get Device List Connected To A Router
```ruby
router.get_connected_devices(access_controller)
router.connected_devices
```

`connected_devices` returns an Array of devices connected to `router`.

#### Discover All GATT Services
```ruby
router.discover_all_services(access_controller, device_mac: "CC:1B:E0:E7:FE:F9")
device.services
```

`device_mac` is the mac address of the device that you are discovering all GATT services of.

`device` is an `Cassia::Device` object with mac address `device_mac`. `device.services` returns all GATT services provided by `device`.

#### Discover All GATT Characteristics
```ruby
router.discover_all_char(access_controller, device_mac: "CC:1B:E0:E7:FE:F9")
device.characteristics
```

`device_mac` is the mac address of the device that you are discovering all GATT characteristics of.

`device` is an `Cassia::Device` object with mac address `device_mac`. `device.characteristics` returns all GATT characteristics of services provided by `device`.

#### Discover All Characteristics of One Service
```ruby
router.discover_all_char(access_controller, device_mac: "CC:1B:E0:E7:FE:F9", service_uuid: "00001800-0000-1000-800000805f9b34fb")
service.characteristics
```

`device_mac` is the mac address of the device that you are discovering GATT characteristics of.

`servide_uuid` is the uuid of the service that you are discovering GATT characteristics of.

`service` is an `Cassia::Service` object with uuid `service_uuid`. `service.characteristics` returns all GATT characteristics of `service`.

#### Discover All Characteristics And Services
```ruby
router.discover_all_services_and_chars(access_controller, device_mac: "CC:1B:E0:E7:FE:F9")
device.services
device.characteristics
```

`device_mac` is the mac address of the device that you are discovering GATT characteristics and services of.

`device` is an `Cassia::Device` object with mac address `device_mac`. `device.services` returns all GATT services provided by `device`.
`device.characteristics` returns all GATT characteristics of services provided by `device`.

#### Write Value Of A Characteristic
```ruby
router.write_char_by_handle(access_controller, device_mac: "CC:1B:E0:E7:FE:F9", handle: 3, value: "0100")
```

`device_mac` is the mac address of the device that you are writing GATT characteristic to.

`handle` is the handle of the characteristic that you are writing.

`value` refers to the function you would like executed. To open the notification, set `value` to "0100". To close the notification, set `value` to "0000".

#### Open Notification of A Characteristic
```ruby
router.open_char_notification(access_controller, device_mac: "CC:1B:E0:E7:FE:F9", handle: 3)
```

`device_mac` is the mac address of the device whose characteristic is being turned on notification.

`handle` is the handle of the characteristic that you are turning notification on.

#### Close Notification of A Characteristic
```ruby
router.close_char_notification(access_controller, device_mac: "CC:1B:E0:E7:FE:F9", handle: 3)
```

`device_mac` is the mac address of the device whose characteristic is being turned off notification.

`handle` is the handle of the characteristic that you are turning notification off.

### Characteristics

A class whose objects contain attributes of a characteristic of some service provided by a BLE device.

### Devices

A class whose objects contain attributes of a BLE device.

### Services

A class whose objects contain attributes of a service provided by a BLE device.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/iteratelabs/cassia-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Cassia::Ruby project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/iteratelabs/cassia-ruby/blob/master/CODE_OF_CONDUCT.md).
