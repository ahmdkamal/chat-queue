class MessageWorker
  include Sidekiq::Worker

  def perform(body, chat_number, message_number)
    Message.create(body: body, chat_number: chat_number, message_number: message_number)
  end
end