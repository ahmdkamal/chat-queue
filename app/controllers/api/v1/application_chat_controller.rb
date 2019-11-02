# frozen_string_literal: true
module Api
  module V1
    ## Application Chat Class
    class ApplicationChatController < ApplicationController

      before_action :validate_params, only: [:create, :update]
      before_action :validate_existance, only: [:show, :update, :delete]

      def index
        @applications = Application.order(created_at: :desc).select(:name, :application_token)
        @applications_without_ids = []
        @applications.each do |application|
          @applications_without_ids.push('application_name' => application.name,
                                         'application_token' => application.application_token)
        end
        render json: {status: 'success', data: @applications_without_ids}
      end

      def create
        @application = Application.create(name: params[:name],
                                          application_token: SecureRandom.alphanumeric(8))
        @application = {'application_name' => @application.name, 'application_token' => @application.application_token}
        render json: {status: 'success', data: @application}, status: 201
      end

      def show
        @application = {'application_name' => @application.name, 'application_token' => @application.application_token}
        render json: {status: 'success', data: @application}
      end

      def update
        @application.update(params.permit(:name))
        @application = {'application_name' => @application.name, 'application_token' => @application.application_token}
        render json: {status: 'success', data: @application}
      end

      def delete
        @application.delete
        head(204)
      end

      private
      def validate_params
        render json: {status: 'failed', errors: 'name is required'}, status: 400 if params.permit(:name).blank?
      end

      def validate_existance
        @application = Application.find_by(application_token: params[:application_token])
        render json: {status: 'failed', errors: 'application not found'}, status: 404 unless @application
      end

    end
  end
end
