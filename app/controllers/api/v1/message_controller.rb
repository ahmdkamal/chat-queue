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
        @messages = Message.where(chat_number: params[:chat_number]).order(created_at: :desc).all
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
        @message = Message.create(chat_number: params[:chat_number], body: params[:body])
        @message.update(message_number: @message.id)
        @message = {'message_number' => @message.message_number, 'chat_number' => @message.chat_number, 'body' => @message.body}
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
        @chat = Chat.where(chat_number: params[:chat_number]).first
        render json: {status: 'failed', errors: 'chat not found'}, status: 404 unless @chat
      end

      def validate_message_existance
        @message = Message.find_by(message_number: params[:message_number])
        render json: { message: 'not found' }, status: 404 unless @message
      end

      def validate_params
        render json: {status: 'failed', errors: 'body is required'}, status: 400 if params.permit(:body).blank?
      end

    end
  end
end