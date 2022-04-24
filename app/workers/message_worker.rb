class MessageWorker
  include Sidekiq::Worker

  def perform(number, token, message_number, message_content)
    @chat = Chat.find_by!(number: number, application_id: token)
    @message = @chat.messages.new({'content' => message_content, 'number' => message_number})
    @message.save!
  end
end
