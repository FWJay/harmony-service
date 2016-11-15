class Harmony::Service::Message::TrelloActionList::Update < Harmony::Service::Message::TrelloActionList::Request
  attr_accessor :card_id, :board_name, :list_name
end