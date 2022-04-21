class ChatsController < ApplicationController
    before_action :get_application
    before_action :find_chat, only: [:show, :update, :destroy]
    before_action :chat_number, only: [:create]

    def index
        @chats = @application.chats
        render json: @chats.as_json(only: [:number, :name])
    end

    def show
        render json: @chat.as_json(only: [:number, :name])
    end

    def create
        @chat = @application.chats.new(chat_params)
        @chat.number = @chat_number
        @chat.save!
        render json: @chat.as_json(only: [:number, :name])
    end

    def update
        if @chat.update(chat_params)
            render json: @chat
        else
            render json: @chat.error, status: :unprocessable_entity
        end
    end

    def destroy
        if @chat
            @chat.destroy
            render status: :no_content
        else
            render json: {error: 'Not Found'}, status: :not_found
        end
    end

    private 

    def chat_params
        params.require(:chat).permit(:name)
    end

    def find_chat
        @chat = @application.chats.find_by_number!(params[:number])
    end

    def get_application
        @application = Application.find_by_token!(params[:application_token])
    end

    def chat_number 
        if @application.chats.maximum('number')
            @chat_number = @application.chats.maximum('number') + 1
        else
            @chat_number = 1
        end
    end
end
