require 'spec_helper'

describe Harmony::Service::RpcService do
  
  describe "#work_with_params" do
    let(:metadata) { instance_double("Metadata", reply_to: "harmony.trello", correlation_id: "abc123") }
      
    context "ack!" do
      before(:each) do
        allow(subject).to receive(:work_with_request) { response }
        allow(subject).to receive(:send_response)
        allow(subject).to receive(:ack!)          
        subject.work_with_params(Oj.dump(request), {}, metadata)
      end    
      
      context "calculation" do
        let(:request) { Harmony::Service::Calculator::Request.new(harmony_user_email: "matt@futureworkshops.com", inputs: {"lat" => "51.0", "lon" => "0.1"}) }
        let(:response) { Harmony::Service::Calculator::Response.new(outputs: {price: 50})}
      
        it { expect(subject).to have_received(:work_with_request).with(kind_of(Harmony::Service::Calculator::Request)) }    
        it { expect(subject).to have_received(:send_response).with("{\"^o\":\"Harmony::Service::Calculator::Response\",\"outputs\":{\":price\":50}}", "harmony.trello", "abc123") }
        it { expect(subject).to have_received(:ack!) }
      end
      
      context "action list" do
        context "list" do
          let(:request) { Harmony::Service::ActionList::ListRequest.new(harmony_user_email: "matt@futureworkshops.com", page: 0, per_page: 10) }
          let(:response) { [Harmony::Service::ActionList::Item.new({id: 1, title: "Carrots"})]}
      
          it { expect(subject).to have_received(:work_with_request).with(kind_of(Harmony::Service::ActionList::ListRequest)) }    
          it { expect(subject).to have_received(:send_response).with("[{\"^o\":\"Harmony::Service::ActionList::Item\",\"id\":1,\"title\":\"Carrots\"}]", "harmony.trello", "abc123") }
          it { expect(subject).to have_received(:ack!) }
        end
        
        context "item" do
          let(:request) { Harmony::Service::ActionList::ItemRequest.new(harmony_user_email: "matt@futureworkshops.com", id: 1) }
          let(:response) { Harmony::Service::ActionList::Item.new({id: 1, title: "Carrots", subtitle: "Bag of Carrots", detail_html: "<html><body>Carrots</body></html>"})}
      
          it { expect(subject).to have_received(:work_with_request).with(kind_of(Harmony::Service::ActionList::ItemRequest)) }    
          it { expect(subject).to have_received(:send_response).with("{\"^o\":\"Harmony::Service::ActionList::Item\",\"id\":1,\"title\":\"Carrots\",\"subtitle\":\"Bag of Carrots\",\"detail_html\":\"<html><body>Carrots</body></html>\"}", "harmony.trello", "abc123") }
          it { expect(subject).to have_received(:ack!) }
        end
        
        context "action" do
          let(:request) { Harmony::Service::ActionList::ActionRequest.new(harmony_user_email: "matt@futureworkshops.com", id: 1, action: "Done") }
          let(:response) { nil }
      
          it { expect(subject).to have_received(:work_with_request).with(kind_of(Harmony::Service::ActionList::ActionRequest)) }    
          it { expect(subject).to have_received(:send_response).with("null", "harmony.trello", "abc123") }
          it { expect(subject).to have_received(:ack!) }
        end
      end
      
      context "chart" do
        
        let(:request) { Harmony::Service::Chart::Request.new(harmony_user_email: "matt@futureworkshops.com") }
        let(:response) { Harmony::Service::Chart::Response.new(x_values: ["Jan", "Feb", "Mar"], y_values: [10, 20, 40])}
      
        it { expect(subject).to have_received(:work_with_request).with(kind_of(Harmony::Service::Chart::Request)) }    
        it { expect(subject).to have_received(:send_response).with("{\"^o\":\"Harmony::Service::Chart::Response\",\"x_values\":[\"Jan\",\"Feb\",\"Mar\"],\"y_values\":[10,20,40]}", "harmony.trello", "abc123") }
        it { expect(subject).to have_received(:ack!) }
        
      end
      
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