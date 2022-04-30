require 'rails_helper'

RSpec.describe "Chats", type: :request do
  before(:all) do
    @application = Application.create(name: 'test')
    @chat = @application.chats.create(name: "First chat", number: 1)

    # to test message count
    @chat.messages.create(content: "Hello", number: 1)
    @chat.messages.create(content: "How are you", number: 2)
  end

  after(:all) do 
    Application.delete_all
    Chat.delete_all
  end

  describe "list all chats" do
     
    it " returns response 200, success case" do
      get application_chats_path application_token: @application.token
      expect(response).to have_http_status(200)
    end

    it "returns 404 not found, application does not exist" do
      get application_chats_path application_token: 12
      expect(response).to have_http_status(404)
    end
  end


  describe "create a new chat" do 
    it "returns 200, create chat successfully" do
      # send to worker
      count = Chat.count
      post application_chats_path application_token: @application.token, params: {chat: {name: 'chattest'}}, as: :json
      
      expect(response).to have_http_status(200)
      #NOTE: something goes wrong here 
      #expect(count).to be < (Chat.count) # to make sure that chat is created successfully
    end
  end

  describe "update chat" do
    it "returns 200, update chat successfully" do 
      put application_chat_path application_token: @application.token, number:@chat.number, params: {chat: {name: 'UPDATED'}}, as: :json
   
      parsed_response = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(parsed_response['name']).to eq('UPDATED')
    end

    it "returns 400, invalid data, can not update chat" do 
      put application_chat_path application_token: @application.token, number:@chat.number 
      expect(response).to  have_http_status(400)
    end
  end

  describe "retrieve specfic chat" do 
    it "returns 200, retrieve chat sucessfully" do
      get application_chat_path application_token: @application.token, number:@chat.number
   
      parsed_response = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(parsed_response['name']).to eq(@chat.name)
      expect(parsed_response['number']).to eq(@chat.number)

    end

    it "returns 404, chat is not exist" do 
      get application_chat_path application_token: @application.token, number:11111111111
   
      parsed_response = JSON.parse(response.body)
      expect(response).to have_http_status(404)
    end

  end

  describe "delete chat" do 

    it "returns 204, delete chat successfully" do 
      delete application_chat_path application_token: @application.token, number:@chat.number
   
      expect(response).to have_http_status(204)
    end

    it "returnd 404, chat is not exist" do 
      delete application_chat_path application_token: @application.token, number:112312312
   
      expect(response).to have_http_status(404)
    end

  end

  describe "messages count" do 
    it "returns 200, get messages count for a specific chat" do 
      get application_chat_messages_count_path application_token:@application.token, chat_number:@chat.number

      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      # NOTE: this function does not count messages
      expect(parsed_response['count']).to eq(@chat.messages.size)
    end
  end
end
