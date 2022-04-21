class Message < ApplicationRecord
    belongs_to :chats, optional: true
    include Searchable
    
end
