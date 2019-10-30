class Application < ApplicationRecord
  validates :name, presence: true
  validates :token, presence: true

  has_many :chats, :foreign_key => :token
end
