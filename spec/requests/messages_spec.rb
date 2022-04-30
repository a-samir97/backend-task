require 'rails_helper'

RSpec.describe "Messages", type: :request do
  before(:all) do
    @application = Application.create(name: 'test', token: 'testtesttoken')
    @chat = @application.chats.create(name: 'testchat', number: 1)
    @message = @chat.messages.create(content: 'test content',number: 1)
    @chat.messages.create(content: 'test python', number: 2)
    @chat.messages.create(content: 'test rspec', number:3)
    @chat.messages.create(content: 'ruby on rails', number: 4)
  end

  after(:all) do 
    Application.delete_all
    Chat.delete_all
    Message.delete_all
    Message.__elasticsearch__.delete_index!
  end
  
  describe "list of all messages" do

    it "returns 200" do
      get application_chat_messages_path application_token: @application.token, chat_number: @chat.number
      expect(response).to have_http_status(200)
    end

    it "returns 404, application does not exist" do 
      get application_chat_messages_path application_token: 123, chat_number: @chat.number
      expect(response).to have_http_status(404)
    end

    it "returns 404, chat does not exist" do
      get application_chat_messages_path application_token: @application.token, chat_number: 123123123
      expect(response).to have_http_status(404)
    end
  end

  describe "create a new message" do 
    it "returns 200" do 
      # send to worker 
      post application_chat_messages_path application_token: @application.token, chat_number: @chat.number,  params: {message: {content: 'new message'}}, as: :json

      expect(response).to have_http_status(200)
    end
  end

  describe "Update message" do 
    it "returns 200" do 
      put application_chat_message_path application_token: @application.token, chat_number: @chat.number, number: @message.number,  params: {message: {content: 'new message UPDATED'}}, as: :json
      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(parsed_response['content']).to eq('new message UPDATED')
    end

    it "returns 400, invalid data" do 
      put application_chat_message_path application_token: @application.token, chat_number: @chat.number, number: @message.number
      expect(response).to have_http_status(400)
    end

    it "returns 404, message is not exist" do 
      put application_chat_message_path application_token: @application.token, chat_number: @chat.number, number: 123123,  params: {message: {content: 'new message UPDATED'}}, as: :json
      expect(response).to have_http_status(404)
    end

  end


  describe "retrieve message" do 
    it "returns 200" do 
      get application_chat_message_path application_token: @application.token, chat_number: @chat.number, number: @message.number
      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(parsed_response['content']).to eq(@message.content)
      expect(parsed_response['number']).to eq(@message.number)
    end

    it "returns 404, message is not exist" do 
      get application_chat_message_path application_token: @application.token, chat_number: @chat.number, number: 123123
      expect(response).to have_http_status(404)
    end
  end

  describe "delete message" do 
    it "returns 204" do 
      delete application_chat_message_path application_token: @application.token, chat_number: @chat.number, number: @message.number
      expect(response).to have_http_status(204)
    end

    it "returns 404, message is not exist" do 
      delete application_chat_message_path application_token: @application.token, chat_number: @chat.number, number: 12233312
      expect(response).to have_http_status(404)
    end
  end

  describe "search for messages" do  
    it "returns 200, search for messages that contain ruby" do 
      get application_chat_messages_search_path application_token: @application.token, chat_number: @chat.number, params: {q: 'ruby'}
      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(parsed_response['messages'].count).to eq(1)
    end

    it "returns 200, search for messages that contain python" do 
      get application_chat_messages_search_path application_token: @application.token, chat_number: @chat.number, params: {q: 'python'}
      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(parsed_response['messages'].count).to eq(1)
    end

    it "returns 200, search for messages that contain test" do 
      get application_chat_messages_search_path application_token: @application.token, chat_number: @chat.number, params: {q: 'test'}
      parsed_response = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(parsed_response['messages'].count).to eq(3)
    end
  end
end
