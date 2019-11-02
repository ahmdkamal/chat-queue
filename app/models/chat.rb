class Chat < ApplicationRecord
  has_many :messages, :foreign_key => :chat_number
  belongs_to :application, :foreign_key => :application_token
end

