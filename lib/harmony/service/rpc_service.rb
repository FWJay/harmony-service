require 'sneakers'
require 'sneakers/metrics/logging_metrics'
require 'sneakers/handlers/maxretry'
require 'json'
require 'oj'
require 'rollbar'

module Harmony
  module Service
    class RpcService
      include Sneakers::Worker
      from_queue ENV['harmony_queue'], timeout_job_after: 10, threads: 1
  
      def work_with_params(message, delivery_info, metadata)
        begin
          logger.debug "Request: #{message}"
          request = Oj.load(message)
          request_class = request.class
          response_class = request_response_mapping[request_class]
          raise "Unacceptable request class: #{request_class}" if response_class.nil?
          
          result = new_handler.work_with_request(request)
          raise "Unacceptable response class: #{result.class}" unless response_class === result
          
          json = Oj.dump(result)
          logger.debug "Response: #{json}"
          send_response(json, metadata.reply_to, metadata.correlation_id)
          ack!
        rescue StandardError => error
          logger.error error.message
          logger.error error.backtrace.join("\n")
          
          Rollbar.error(error)
          
          error_response = ErrorResponse.new
          error_response.message = "An error occured."
          error_response.detailed_message = error.message
          json = Oj.dump(error_response)
          logger.debug "Response: #{json}"  
            
          send_response(json, metadata.reply_to, metadata.correlation_id)
          reject!
        end
      end
  
      def stop
        super
        #reply_to_exchange.close # not working
        reply_to_connection.close
      end
  
      def reply_to_connection
        @reply_to_connection ||= create_reply_to_connection
      end
  
      def create_reply_to_connection
        opts = Sneakers::CONFIG
        conn = Bunny.new(opts[:amqp], :vhost => opts[:vhost], :heartbeat => opts[:heartbeat], :logger => Sneakers::logger)
        conn.start
        conn
      end
  
      def reply_to_exchange
        @reply_to_queue ||= create_reply_to_exchange
      end
  
      def create_reply_to_exchange
        ch = reply_to_connection.create_channel
        ch.exchange(AMQ::Protocol::EMPTY_STRING, :auto_delete => true)    
      end
  
      def send_response(result, reply_to, correlation_id)
        reply_to_exchange.publish(result, :routing_key => reply_to, :correlation_id => correlation_id)
      end
      
      private
      def request_response_mapping
        {
          Calculator::Request => Calculator::Response,
          ActionList::ListRequest => Array,
          ActionList::ItemRequest => ActionList::Item,
          ActionList::ActionRequest => NilClass,
          Chart::Request => Chart::Response,
          Form::GetRequest => Form::GetResponse,
          Flow::EndedRequest => Response
        }
      end
      
      def new_handler
        handler_class = Sneakers::CONFIG[:handler_class]
        raise "No handler specified" if handler_class.nil? 
        
        handler = Object.const_get(handler_class).new
        raise "Unable to create handler: #{handler_class}" if handler.nil? 
      end
    end
  end
end