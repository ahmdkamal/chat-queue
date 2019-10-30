# frozen_string_literal: true
module Api
  module V1
    ## Chat Class
    class ChatController < ApplicationController
      def index
        @application = Application.where(token: params[:application_token]).first
        if @application.nil?
          render json: {status: 'failed', data: 'no such application'}, status: 400
          return
        end
        @chats = Chat.select(:number, :token).where(token: params[:application_token])
                     .order(created_at: :desc).all
        @chats_without_ids = []
        @chats.each do |chat|
          @chats_without_ids.push(
              'application_token' => chat.token,
              'chat_number' => chat.number,
          )
        end
        render json: {status: 'success', data: @chats_without_ids}
      end

      def create
        @application = Application.where(token: params[:application_token]).first
        if @application.nil?
          render json: {status: 'failed', data: 'no such application'}, status: 400
          return
        end
        if params[:number].to_i < 1
          render json: {status: 'failed', errors: 'chat number should be >= 1'}, status: 400
          return
        end
        if Chat.where(number: params[:number].to_i).blank? == false
          render json: {status: 'failed', errors: 'chat already exist'}, status: 400
          return
        end
        @chat = Chat.create(number: params[:number].to_i, token: params[:application_token])
        @chat = {'application_token' => @chat.token, 'chat_number' => @chat.number}
        render json: {status: 'success', data: @chat}, status: 201
      end

      def show
        @application = Application.where(token: params[:application_token]).first
        if @application.nil?
          render json: {status: 'failed', data: 'no such application'}, status: 400
          return
        end
        if params[:chat_number].to_i < 1
          render json: {status: 'failed', errors: 'chat number should be >= 1'}, status: 400
          return
        end
        @chat = Chat.where(number: params[:chat_number].to_i, token: params[:application_token]).first
        if @chat.blank?
          render json: {status: 'failed', errors: 'no such chat'}, status: 400
        else
          @chat = {'application_token' => @chat.token, 'chat_number' => @chat.number}
          render json: {status: 'success', data: @chat}
        end
      end

      def delete
        @application = Application.where(token: params[:application_token]).first
        if @application.nil?
          render json: {status: 'failed', data: 'no such application'}, status: 400
          return
        end
        if params[:chat_number].to_i < 1
          render json: {status: 'failed', errors: 'chat number should be >= 1'}, status: 400
          return
        end
        @chat = Chat.where(number: params[:chat_number].to_i, token: params[:application_token]).first
        if @chat.blank?
          render json: {status: 'failed', errors: 'no such chat'}, status: 400
        else
          @chat.delete
          head(204)
        end
      end
    end
  end
end
