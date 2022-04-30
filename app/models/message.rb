class Message < ApplicationRecord
    include Searchable
    belongs_to :chat, optional: true, counter_cache: true
end
