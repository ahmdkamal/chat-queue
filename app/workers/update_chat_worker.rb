class UpdateChatWorker
  include Sidekiq::Worker

  def perform(chat, delete = false)
    # byebug
    @chat = Chat.find(chat)
    if delete
      @chat.update(messages_count: @chat.messages_count + 1)
    else
      @chat.update(messages_count: @chat.messages_count -1)
    end
  end
end