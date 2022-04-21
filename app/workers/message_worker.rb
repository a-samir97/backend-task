class MessageWorker
  include Sidekiq::Worker

  def perform(chat_number, message_number, params)
  end
end
