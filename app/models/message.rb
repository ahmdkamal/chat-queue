class Message < ApplicationRecord
  validates :number, presence: true

  belongs_to :chat, :foreign_key => :chat_number
end
