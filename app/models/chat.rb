class Chat < ApplicationRecord
  belongs_to :application, optional: true
  has_many :messages, dependent: :destroy, primary_key: 'number'
end
