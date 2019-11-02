class ChatWorker
  include Sidekiq::Worker

  def perform(application_token, chat_number)
    Chat.create(application_token: application_token, chat_number: chat_number)
  end
end