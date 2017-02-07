# Harmony::Service

The Harmony Service gem simplifies creation of a micro-service (Service) in the Harmony Platform.

You can connect your Service to pages and Apps inside Harmony. Whenever a page or App connected to your service is triggered it will route a message through to your service with a representative class. You should respond with the appropriate class encapsulating any data you want to display. For example, if your Service recieves a ``Harmony::Service::Chart::Request``, it should return a ``Harmony::Service::Chart::Response``.

You can find the relevant mappings [here](https://github.com/HarmonyMobile/harmony-service/blob/master/lib/harmony/service/rpc_service.rb#L95). 

## Installation

1. Create a new Service via the Harmony platform
1. Download the [Harmony Service Template](https://github.com/HarmonyMobile/harmony-service-template).
1. Add your own code. You will need to use your own source code control.

## Usage

In order to test your code locally you can run `bundle exec rspec`. Once you have completed development you can upload into  Harmony Platform.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
