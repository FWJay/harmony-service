class Harmony::Service::Message
  def self.attr_accessor(*vars)
    @attributes ||= []
    @attributes.concat vars
    super(*vars)
  end

  def self.attributes
    @attributes
  end
  
  def initialize(h = {})
    h.each {|k,v| instance_variable_set("@#{k}",v)}
  end

  def attributes
    self.class.attributes || []
  end

  def self.json_create(o)
    new(*o['data'])
  end
end