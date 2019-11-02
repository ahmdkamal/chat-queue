require 'elasticsearch/model'

class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :chat, :foreign_key => :chat_number

  def self.search(query)
    __elasticsearch__.search({
            query: {
                multi_match: {
                query: query,
                fields: ['body'],
                fuzziness: "auto",
                lenient: true
                }
            }
        })
  end
end