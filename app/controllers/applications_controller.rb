class ApplicationsController < ApplicationController

    before_action :find_application, only: [:show, :update, :destroy, :count]

    # GET applications/
    def index 
        @applications = Application.all
        render json: @applications.as_json(only: [:token, :name]), status: :ok

    end

    # GET applications/:token
    def show
        # need to add index in token column
        render json: @application.as_json(only: [:token, :name]), status: :ok
    end

    # POST applications/
    def create
        @application = Application.create(application_param)
        render json: @application.as_json(only: [:token, :name]), status: :created
    end

    # UPDATE applications/:token
    def update
        @application.update(application_param)
        render json: @application.as_json(only: [:token, :name]), status: :ok
    end

    # DELETE applications/:token
    def destroy
        @application.destroy
        render json: { message: 'Application successfully deleted.'}, status: :no_content
    end

    def count 
        # get counts of chats per each application 
        render json: {count: @application.chats.size}, status: 200
    end

    private

    def application_param
        params.require(:application).permit(:name)
    end

    def find_application
        token = params[:token] ? params[:token] : params[:application_token]
        @application = Application.find_by_token!(token)
    end
end
