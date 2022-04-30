class MessagesController < ApplicationController

    before_action :get_chat
    before_action :get_message, only: [:show, :update, :destroy]
    before_action :message_number, only: [:create]

    def index
        @messages = @chat.messages
        render json: @messages.as_json(only: [:number, :content])
    end

    def show
        render json: @message.as_json(only: [:number, :content])
    end

    def create
        # add mesage data to queue system
        MessageWorker.perform_async(@chat.number, params[:application_token], @message_number, message_params[:content])
        render json: {data: 'Message is created successfully.'}, status: :ok
    end


    def update
        if @message.update(message_params)
            render json: @message
        else
            render json: @message.error, status: :unprocessable_entity
        end
    end

    def destroy
        @message.destroy
        render json: { message: 'Message is deleted successfully.'}, status: :no_content
    end

    # Using ElasticSearch
    def search
        results = @chat.messages.search(search_params[:q])
        messages =  results.map do |r|
            r[:_source].as_json(only: [:number, :content])
        end
        render json: { messages: messages }, status: :ok
      end
     

    private

    def search_params
        params.permit(:q)
      end

    def message_params
        params.require(:message).permit(:content)
    end

    def get_chat
        @chat = Chat.find_by!(number: params[:chat_number], application_id: params[:application_token])
    end

    def get_message
        @message = @chat.messages.find_by_number!(params[:number])
    end

    def message_number
        @message_number = @chat.messages.maximum("number") ? @chat.messages.maximum("number") + 1 : 1
    end
end
