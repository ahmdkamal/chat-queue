require 'elasticsearch/model'

class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  validates :number, presence: true
  belongs_to :chat, :foreign_key => :chat_number

  settings do
    mappings dynamic: false do
      indexes :body, type: :text, analyzer: :english
    end
  end
end
