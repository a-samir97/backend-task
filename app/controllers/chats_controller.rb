class ChatsController < ApplicationController
    before_action :get_application
    before_action :find_chat, only: [:show, :update, :destroy, :count]
    before_action :chat_number, only: [:create]

    def index
        @chats = @application.chats
        render json: @chats.as_json(only: [:number, :name])
    end

    def show
        render json: @chat.as_json(only: [:number, :name])
    end

    def create
        # add chat data to queue
        ChatWorker::perform_async(@application.token, @chat_number, chat_params[:name])
        render json: {data: 'Chat is created sucessfully.'}, status: :ok
    end

    def update
        if @chat.update(chat_params)
            render json: @chat.as_json(only: [:number, :name])
        else
            render json: @chat.error, status: :unprocessable_entity
        end
    end

    def destroy
        @chat.destroy
        render json: { message: 'Chat is deleted successfully.'}, status: :no_content
    end

    def count
        render json: {count: @chat.messages.size}, status: 200
    end

    private 

    def chat_params
        params.require(:chat).permit(:name)
    end

    def find_chat
        number = params[:number] ? params[:number] : params[:chat_number]
        @chat = @application.chats.find_by_number!(number)
    end

    def get_application
        @application = Application.find_by_token!(params[:application_token])
    end

    def chat_number
        @chat_number = @application.chats.maximum('number') ? @application.chats.maximum('number') + 1 : 1
    end
end
