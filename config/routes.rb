Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace 'api' do
    namespace 'v1' do
      scope :applications do
        get '/', to: 'application_chat#index'
        post '/', to: 'application_chat#create'
        get ':application_token', to: 'application_chat#show'
        put ':application_token', to: 'application_chat#update'
        delete ':application_token', to: 'application_chat#delete'

        scope '/:application_token/chats' do
          get '/', to: 'chat#index'
          post '/', to: 'chat#create'
          get ':chat_number', to: 'chat#show'
          delete ':chat_number', to: 'chat#delete'

          scope '/:chat_number/messages' do
            get '/', to: 'message#index'
            post '/', to: 'message#create'
            get '/search/:word', to: 'message#search'
            get ':message_number', to: 'message#show'
            put ':message_number', to: 'message#update'
            delete ':message_number', to: 'message#delete'
          end
        end

      end
    end
  end
end
