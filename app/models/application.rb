class Application < ApplicationRecord
    has_many :chats, dependent: :destroy, primary_key: 'token'
    before_create :generate_token

  private
    def generate_token
        self.token = SecureRandom.urlsafe_base64
    end
end
