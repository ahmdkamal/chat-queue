class Application < ApplicationRecord
  validates :name, presence: true
  validates :application_token, presence: true

  has_many :chats, :foreign_key => :application_token, primary_key: :application_token
end
