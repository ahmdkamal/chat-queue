class Chat < ApplicationRecord
  validates :number, presence: true

  has_many :messages, :foreign_key => :chat_number
  belongs_to :application, :foreign_key => :token, optional: true
end

