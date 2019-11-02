class Chat < ApplicationRecord
  after_commit :increase_chats, on: :create
  before_commit :decrease_chats, on: :delete

  def increase_chats
    @application = Chat.last.application
    ::UpdateApplicationWorker.perform_in(1.hour, @application.id)
  end

  has_many :messages, :foreign_key => :chat_number, :primary_key => :chat_number
  belongs_to :application, :foreign_key => :application_token, primary_key: :application_token
end

