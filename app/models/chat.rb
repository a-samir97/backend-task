class Chat < ApplicationRecord
  belongs_to :application
  has_many :messages, dependent: :destroy, primary_key: 'number'
end
