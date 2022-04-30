class Chat < ApplicationRecord
  belongs_to :application, optional: true, counter_cache: true
  has_many :messages, dependent: :destroy, primary_key: 'number'
end
