class ChatWorker
  include Sidekiq::Worker

  def perform(token, chat_number, chat_name)
    @application = Application.find_by_token!(token)
    @chat = @application.chats.new({'name' => chat_name, 'number' => chat_number})
    @chat.save!
  end
end
