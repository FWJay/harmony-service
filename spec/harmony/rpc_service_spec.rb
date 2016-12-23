require 'spec_helper'

describe Harmony::Service::RpcService do
  
  describe "#work_with_params" do    
    context "with calculation request" do
      let(:request) { Harmony::Service::Calculator::Request.new(harmony_user_email: "matt@futureworkshops.com", inputs: {"lat" => "51.0", "lon" => "0.1"}) }
      let(:response) { Harmony::Service::Calculator::Response.new(outputs: {price: 50})}
      
      before(:each) do
        allow(subject).to receive(:work_with_request) { response }
        allow(subject).to receive(:send_response)
        allow(subject).to receive(:ack!)
            
        metadata = instance_double("Metadata", reply_to: "harmony.trello", correlation_id: "abc123")
        subject.work_with_params(Oj.dump(request), {}, metadata)
      end

      it { expect(subject).to have_received(:work_with_request).with(kind_of(Harmony::Service::Calculator::Request)) }    
      it { expect(subject).to have_received(:send_response).with("{\"^o\":\"Harmony::Service::Calculator::Response\",\"outputs\":{\":price\":50}}", "harmony.trello", "abc123") }
      it { expect(subject).to have_received(:ack!) }
    end
  
    context "unacceptable request class" do
      before(:each) do
        allow(subject).to receive(:work_with_request).and_raise("A timeout occured")
        allow(subject).to receive(:send_response)
        allow(subject).to receive(:reject!)
            
        metadata = instance_double("Metadata", reply_to: "harmony.trello", correlation_id: "abc123")
        subject.work_with_params("{\"trello_board_id\": \"12345\"}", {}, metadata)
      end
    
      it { expect(subject).to have_received(:send_response).with("{\"^o\":\"Harmony::Service::ErrorResponse\",\"message\":\"An error occured.\",\"detailed_message\":\"Unacceptable request class: Hash\"}", "harmony.trello", "abc123") }
      it { expect(subject).to have_received(:reject!) }
    end
  end
  

end