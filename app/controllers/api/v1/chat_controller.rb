# frozen_string_literal: true
module Api
  module V1
    ## Chat Class
    class ChatController < ApplicationController
      before_action :validate_application_existance
      before_action :validate_chat_existance, only: [:show, :delete]

      def index
        @chats = Chat.where(application_token: params[:application_token]).order(created_at: :desc).all
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
        @chat = Chat.create(application_token: params[:application_token])
        @chat.update(chat_number: @chat.id)
        @chat = {'application_token' => @chat.application_token, 'chat_number' => @chat.chat_number}
        render json: {status: 'success', data: @chat}, status: 201
      end

      def show
          @chat = {'application_token' => @chat.application_token, 'chat_number' => @chat.chat_number}
          render json: {status: 'success', data: @chat}
      end

      def delete
        @chat.delete
        head(204)
      end

      private
      def validate_application_existance
        @application = Application.find_by(application_token: params[:application_token])
        render json: {status: 'failed', errors: 'application not found'}, status: 404 unless @application
      end

      def validate_chat_existance
        @chat = Chat.where(application_token: params[:application_token], chat_number: params[:chat_number]).first
        render json: {status: 'failed', errors: 'chat not found'}, status: 404 unless @chat
      end

    end
  end
end
