class ApplicationsController < ApplicationController

    before_action :find_application, only: [:show, :update, :destroy]

    # GET applications/
    def index 
        @applications = Application.all
        render json: @applications

    end

    # GET applications/:token
    def show
        # need to add index in token column
        render json: @application.as_json(only: [:token, :name])
    end

    # POST applications/
    def create
        @application = Application.new(application_param)
        if @application.save
            render json: @application.as_json(only: [:token, :name])
        else
            render error: { error: 'Unable to create Application.'}, status: 400
        end
    end

    # UPDATE applications/:token
    def update
        if @application
            @application.update(application_param)
            render json: { message: 'Application successfully update.'}, status:200
        else
            render json: { error: 'Unable to update Application.'}, status:400
        end
    end

    # DELETE applications/:token
    def destroy
        if @application
            @application.destroy
            render json: { message: 'Application successfully deleted.'}, status:200
        else
            render json: { error: 'Unable to delete Application. '}, status:400
        end
    end

    private

    def application_param
        params.require(:application).permit(:name)
    end

    def find_application
        @application = Application.find_by_token!(params[:token])
    end
end
