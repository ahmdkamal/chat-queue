# frozen_string_literal: true
module Api
  module V1
    ## Application Chat Class
    class ApplicationChatController < ApplicationController
      def index
        @applications = Application.order(created_at: :desc).select(:name, :token)
        @applications_without_ids = []
        @applications.each do |application|
          @applications_without_ids.push('application_name' => application.name,
                                         'token' => application.token)
        end
        render json: {status: 'success', data: @applications_without_ids}
      end

      def create
        @application = Application.create(name: params[:name],
                                          token: SecureRandom.alphanumeric(8))
        @application = {'application_name' => @application.name, 'token' => @application.token}
        render json: {status: 'success', data: @application}, status: 201
      end

      def show
        @application = Application.where(token: params[:application_token]).select(:name, :token).first
        if @application.blank?
          render json: {status: 'failed', errors: 'no such application'}, status: 400
        else
          @application = {'application_name' => @application.name, 'token' => @application.token}
          render json: {status: 'success', data: @application}
        end
      end

      def update
        if params.permit(:name).blank?
          render json: {status: 'failed', errors: 'name is required'}, status: 400
        end
        @application = Application.where(token: params[:application_token])
                           .update(params.permit(:name))
        if @application.blank?
          render json: {status: 'failed', errors: 'no such application'}, status: 400
        else
          @application = {'application_name' => @application.name, 'token' => @application.token}
          render json: {status: 'success', data: @application}
        end
      end


      def delete
        @application = Application.where(token: params[:application_token]).first
        if @application.blank?
          render json: {status: 'failed', errors: 'no such application'}, status: 400
        else
          @application.delete
          head(204)
        end
      end
    end
  end
end
