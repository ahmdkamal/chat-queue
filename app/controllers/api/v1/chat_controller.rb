# frozen_string_literal: true
module Api
  module V1
    ## Chat Class
    class ChatController < ApplicationController
      before_action :validate_application_existance
      before_action :validate_chat_existance, only: [:show, :delete]

      def index
        @chats = @application.chats.order(created_at: :desc).all
        @chats_without_ids = []
        @chats.each do |chat|
          @chats_without_ids.push(
              'application_token' => chat.application_token,
              'chat_number' => chat.chat_number,
          )
        end
        render json: {status: 'success', data: @chats_without_ids}
      end

      def create
        @chat_number = $redis.get('chat_number')
        if @chat_number.nil?
          @chat_number = Chat.last.id + 1
          $redis.set('chat_number', @chat_number)
        else
          @chat_number = @chat_number.to_i + 1
          $redis.set('chat_number', @chat_number)
        end
        ::ChatWorker.perform_in(10.seconds, params[:application_token], @chat_number)

        @chat = {'application_token' => params[:application_token], 'chat_number' => @chat_number}
        render json: {status: 'success', data: @chat}, status: 201
      end

      def show
        @chat = {'application_token' => @chat.application_token, 'chat_number' => @chat.chat_number}
        render json: {status: 'success', data: @chat}
      end

      def delete
        ::UpdateApplicationWorker.perform_in(1.hour, @application.id, delete = true)
        @chat.delete
        head(204)
      end

      private

      def validate_application_existance
        @application = Application.find_by(application_token: params[:application_token])
        render json: {status: 'failed', errors: 'application not found'}, status: 404 unless @application
      end

      def validate_chat_existance
        @chat = @application.chats.where(chat_number: params[:chat_number]).first
        render json: {status: 'failed', errors: 'chat not found'}, status: 404 unless @chat
      end

    end
  end
end
