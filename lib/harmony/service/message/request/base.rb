module Harmony
  module Service
    module Message
      module Request
        class Base < Harmony::Service::Message::Base
          attr_accessor :harmony_user_email
        end
      end
    end
  end
end