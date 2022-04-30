class ChatWorker
  include Sidekiq::Worker

  def perform(token, chat_number, chat_name)
    @application = Application.find_by_token!(token)
    @chat = @application.chats.create({'name' => chat_name, 'number' => chat_number})
  end
end
