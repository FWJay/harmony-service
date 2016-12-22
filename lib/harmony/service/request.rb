class Harmony::Service::Request < Harmony::Service::Message
  attr_accessor :harmony_user_email, :options
  
  def initialize(h = {})
    super(h)
    @options ||= {}
  end
end

