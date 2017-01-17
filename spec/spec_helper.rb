$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'harmony/service'
require 'byebug'

opts = {
  amqp: 'amqp://localhost:5672',
  vhost: '/',
  exchange: 'sneakers',
  exchange_type: :direct,
  metrics: Sneakers::Metrics::LoggingMetrics.new,
  handler: Sneakers::Handlers::Maxretry,
  handler_class: "MockHandler"
}

Sneakers.configure(opts)
Sneakers.logger.level = Logger::DEBUG

class MockHandler
  
  def work_with_request(request)
    
  end
  
end