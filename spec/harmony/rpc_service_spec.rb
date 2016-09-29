require 'spec_helper'

describe Harmony::Service::RpcService do
  
  context "success" do
    before(:each) do
      allow(subject).to receive(:work_with_message_params) { {"success" => true} }
      allow(subject).to receive(:send_response)
      allow(subject).to receive(:ack!)
            
      metadata = instance_double("Metadata", reply_to: "harmony.trello", correlation_id: "abc123")
      subject.work_with_params("{\"trello_board_id\": \"12345\"}", {}, metadata)
    end
    
    it { expect(subject).to have_received(:send_response).with("{\"success\":true}", "harmony.trello", "abc123") }
    it { expect(subject).to have_received(:ack!) }
  end
  
  context "failure" do
    before(:each) do
      allow(subject).to receive(:work_with_message_params).and_raise("A timeout occured")
      allow(subject).to receive(:send_response)
      allow(subject).to receive(:reject!)
            
      metadata = instance_double("Metadata", reply_to: "harmony.trello", correlation_id: "abc123")
      subject.work_with_params("{\"trello_board_id\": \"12345\"}", {}, metadata)
    end
    
    it { expect(subject).to have_received(:send_response).with("{\"success\":false,\"message\":\"An error occured\",\"detailed_message\":\"A timeout occured\"}", "harmony.trello", "abc123") }
    it { expect(subject).to have_received(:reject!) }
  end
end