# frozen_string_literal: true
module Api
  module V1
    ## Message Class
    class MessageController < ApplicationController

      before_action :validate_application_existance
      before_action :validate_chat_existance
      before_action :validate_message_existance, only: [:show, :update, :delete]
      before_action :validate_params, only: [:create, :update]

      def index
        @messages = @chat.messages.order(created_at: :desc).all
        @messages_without_ids = []
        @messages.each do |message|
          @messages_without_ids.push(
              'chat_number' => message.chat_number,
              'message_number' => message.message_number,
              'body' => message.body
          )
        end
        render json: {status: 'success', data: @messages_without_ids}
      end

      def create
        @message_number = $redis.get('message_number')
        if @message_number.nil?
          @message_number = Message.last.id + 1
          $redis.set('message_number', @message_number)
        else
          @message_number = @message_number.to_i + 1
          $redis.set('message_number', @message_number)
        end
        ::MessageWorker..perform_in(10.seconds, params[:body], @chat.chat_number, @message_number)
        @message = {'message_number' => @message_number, 'chat_number' => @chat.chat_number, 'body' => params[:body]}
        render json: {status: 'success', data: @message}
      end

      def show
        @message = {'message_number' => @message.message_number, 'chat_number' => @message.chat_number, 'body' => @message.body}
        render json: {status: 'success', data: @message}
      end

      def update
        @message.update(params.permit(:body))
        @message = {'message_number' => @message.message_number, 'chat_number' => @message.chat_number, 'body' => @message.body}
        render json: {status: 'success', data: @message}
      end

      def delete
        ::UpdateChatWorker.perform_in(1.hour, @chat.id, delete = true)
        @message.delete
        head(204)
      end

      def search
        @messages = Message.search params[:word]
        @messages_without_ids = []
        @messages.each do |message|
          @messages_without_ids.push(
              'chat_number' => message.chat_number,
              'message_number' => message.message_number,
              'body' => message.body
          )
        end
        render json: {status: 'success', data: @messages_without_ids}
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

      def validate_message_existance
        @message = @chat.messages.find_by(message_number: params[:message_number])
        render json: {status: 'failed', errors: 'message not found'}, status: 404 unless @message
      end

      def validate_params
        render json: {status: 'failed', errors: 'body is required'}, status: 400 if params.permit(:body).blank?
      end

    end
  end
end