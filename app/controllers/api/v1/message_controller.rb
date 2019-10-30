# frozen_string_literal: true
module Api
  module V1
    ## Message Class
    class MessageController < ApplicationController
      def index
        @application = Application.where(token: params[:application_token]).first
        if @application.nil?
          render json: {status: 'failed', data: 'no such application'}, status: 400
          return
        end
        @chat = Chat.where(number: params[:chat_number], token: params[:application_token]).first
        if @chat.nil?
          render json: {status: 'failed', data: 'no such chat'}, status: 400
          return
        end
        @messages = Message.where(chat_number: @chat.number).order(created_at: :desc).all
        @messages_without_ids = []
        @messages.each do |message|
          @messages_without_ids.push(
              'chat_number' => message.chat_number,
              'message_number' => message.number,
              'body' => message.body
          )
        end
        render json: {status: 'success', data: @messages_without_ids}
      end

      def create
        if params.permit(:body).blank?
          render json: {status: 'failed', errors: 'body is required'}, status: 400
          return
        end
        if params.permit(:message_number).blank?
          render json: {status: 'failed', errors: 'message_number is required'}, status: 400
          return
        end
        @application = Application.where(token: params[:application_token]).first
        if @application.nil?
          render json: {status: 'failed', data: 'no such application'}, status: 400
          return
        end
        @chat = Chat.where(number: params[:chat_number], token: params[:application_token]).first
        if @chat.nil?
          render json: {status: 'failed', data: 'no such chat'}, status: 400
          return
        end
        if Message.where(number: params[:message_number].to_i).blank? == false
          render json: {status: 'failed', errors: 'message already exist'}, status: 400
          return
        end
        if params[:message_number].to_i < 1
          render json: {status: 'failed', errors: 'message number should be >= 1'}, status: 400
          return
        end
        @message = Message.create(chat_number: params[:chat_number].to_i,
                                  number: params[:message_number].to_i, body: params[:body])
        @message = {'message_number' => @message.number, 'chat_number' => @message.chat_number, 'body' => @message.body}
        render json: {status: 'success', data: @message}
      end

      def show
        @application = Application.where(token: params[:application_token]).first
        if @application.nil?
          render json: {status: 'failed', data: 'no such application'}, status: 400
          return
        end
        @chat = Chat.where(number: params[:chat_number], token: params[:application_token]).first
        if @chat.nil?
          render json: {status: 'failed', data: 'no such chat'}, status: 400
          return
        end
        if params[:message_number].to_i < 1
          render json: {status: 'failed', errors: 'message number should be >= 1'}, status: 400
          return
        end
        @message = Message.where(chat_number: params[:chat_number].to_i, number: params[:message_number].to_i).first
        if @message.blank?
          render json: {status: 'failed', errors: 'no such message'}, status: 400
        else
          @message = {'message_number' => @message.number, 'chat_number' => @message.chat_number, 'body' => @message.body}
          render json: {status: 'success', data: @message}
        end
      end


      def update
        if params.permit(:body).blank?
          render json: {status: 'failed', errors: 'body is required'}, status: 400
          return
        end
        @application = Application.where(token: params[:application_token]).first
        if @application.nil?
          render json: {status: 'failed', data: 'no such application'}, status: 400
          return
        end
        @chat = Chat.where(number: params[:chat_number], token: params[:application_token]).first
        if @chat.nil?
          render json: {status: 'failed', data: 'no such chat'}, status: 400
          return
        end
        if params[:message_number].to_i < 1
          render json: {status: 'failed', errors: 'message number should be >= 1'}, status: 400
          return
        end
        @message = Message.where(chat_number: params[:chat_number].to_i, number: params[:message_number].to_i).first
        if @message.blank?
          render json: {status: 'failed', errors: 'no such message'}, status: 400
        end
        @message.update(body: params[:body])
        @message = {'message_number' => @message.number, 'chat_number' => @message.chat_number, 'body' => @message.body}
        render json: {status: 'success', data: @message}
      end

      def delete
        @application = Application.where(token: params[:application_token]).first
        if @application.nil?
          render json: {status: 'failed', data: 'no such application'}, status: 400
          return
        end
        @chat = Chat.where(number: params[:chat_number], token: params[:application_token]).first
        if @chat.nil?
          render json: {status: 'failed', data: 'no such chat'}, status: 400
          return
        end
        if params[:message_number].to_i < 1
          render json: {status: 'failed', errors: 'message number should be >= 1'}, status: 400
          return
        end
        @message = Message.where(chat_number: params[:chat_number].to_i, number: params[:message_number].to_i).first
        if @message.blank?
          render json: {status: 'failed', errors: 'no such message'}, status: 400
        else
          @message.delete
          head(204)
        end
      end

      def search
        @messages = Message.search params[:word]
        @messages_without_ids = []
        @messages.each do |message|
          @messages_without_ids.push(
              'chat_number' => message.chat_number,
              'message_number' => message.number,
              'body' => message.body
          )
        end
        render json: {status: 'success', data: @messages_without_ids}
      end
    end
  end
end
