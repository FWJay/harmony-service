class Harmony::Service::Message::TrelloActionList::Index < Harmony::Service::Message::TrelloActionList::Request
  attr_accessor :board_name, :list_name, :page, :per_page
end