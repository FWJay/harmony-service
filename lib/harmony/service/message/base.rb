module Harmony
  module Service
    module Message
      class Base
  
        def self.attr_accessor(*vars)
          @attributes ||= []
          @attributes.concat vars
          super(*vars)
        end

        def self.attributes
          @attributes
        end

        def attributes
          self.class.attributes
        end
  
        def self.json_create(o)
          new(*o['data'])
        end

        def to_json(*a)
          { 'json_class' => self.class.name, 'data' => attributes.collect{|a| instance_variable_get("@#{a}")} }.to_json(*a)
        end
      end
    end
  end
end