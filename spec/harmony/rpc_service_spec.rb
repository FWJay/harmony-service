require 'spec_helper'

describe Harmony::Service::RpcService do
  
  describe "#work_with_params" do
    context "with json" do
      before(:each) do
        allow(subject).to receive(:work_with_request) { {"success" => true} }
        allow(subject).to receive(:send_response)
        allow(subject).to receive(:ack!)
            
        metadata = instance_double("Metadata", reply_to: "harmony.trello", correlation_id: "abc123")
        subject.work_with_params("{\"trello_board_id\": \"12345\"}", {}, metadata)
      end
    
      it { expect(subject).to have_received(:send_response).with("{\"success\":true}", "harmony.trello", "abc123") }
      it { expect(subject).to have_received(:ack!) }
    end
    
    context "with calculation request" do
      let(:request) do
        r = Harmony::Service::Message::Request::Calculation.new
        r.harmony_user_email = "matt@futureworkshops.com"
        r.inputs = {"lat" => "51.0", "lon" => "0.1"}
        r
      end
      
      before(:each) do
        allow(subject).to receive(:work_with_request) { {"success" => true} }
        allow(subject).to receive(:send_response)
        allow(subject).to receive(:ack!)
            
        metadata = instance_double("Metadata", reply_to: "harmony.trello", correlation_id: "abc123")
        subject.work_with_params(Oj.dump(request), {}, metadata)
      end

      it { expect(subject).to have_received(:work_with_request).with(kind_of(Harmony::Service::Message::Request::Calculation)) }    
      it { expect(subject).to have_received(:send_response).with("{\"success\":true}", "harmony.trello", "abc123") }
      it { expect(subject).to have_received(:ack!) }
    end
  
    context "failure" do
      before(:each) do
        allow(subject).to receive(:work_with_request).and_raise("A timeout occured")
        allow(subject).to receive(:send_response)
        allow(subject).to receive(:reject!)
            
        metadata = instance_double("Metadata", reply_to: "harmony.trello", correlation_id: "abc123")
        subject.work_with_params("{\"trello_board_id\": \"12345\"}", {}, metadata)
      end
    
      it { expect(subject).to have_received(:send_response).with("{\"success\":false,\"message\":\"An error occured\",\"detailed_message\":\"A timeout occured\"}", "harmony.trello", "abc123") }
      it { expect(subject).to have_received(:reject!) }
    end
  end
  

end