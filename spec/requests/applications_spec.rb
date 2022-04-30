require 'rails_helper'

RSpec.describe "Applications", type: :request do
  before(:all) do
    @application = Application.create(name: 'test', token: 'testtesttoken')
    @application_2 = Application.create(name: "test2", token: "testtoken2")

    # To test application chats count 
    @application.chats.create(name: "First Chat", number: 1)
    @application.chats.create(name: "Second Chat", number: 2)
  end

  after(:all) do 
    Application.delete_all
    Chat.delete_all
  end
   
  describe "list all applications" do
    it "returns 200" do
      get applications_path
      parsed_body = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(parsed_body.count) == Application.count
      expect(parsed_body).to include @application.as_json(only: [:token, :name])
      expect(parsed_body).to include @application_2.as_json(only: [:token, :name])
    end
  end

  describe "create a new application" do 
    it "returns 201, with valid data" do 
      post applications_path, params: {application: {name: 'testapplication'}}, as: :json
      parsed_response = JSON.parse(response.body)
       
      expect(response).to have_http_status(201)
      expect(parsed_response['name']).to  eq('testapplication')
      expect(parsed_response['token'].class).to eq(String)
    end

    it "returns 400, with invalid data" do
      post applications_path
      expect(response).to have_http_status(400)
    end
  end

  describe "update application" do
    it "returns 200, update the application successfully" do 
      put application_path token:@application.token,  params: {application: {name: 'application UPDATED'}}, as: :json
      parsed_reponse = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(parsed_reponse['name']).to eq('application UPDATED')
    end

    it "returns 400, invalid data" do 
      put application_path token:@application.token
      expect(response).to have_http_status(400)
    end

    it "returns 404, application is not exist" do
      put application_path token:'invalidToken',  params: {application: {name: 'application UPDATED'}}, as: :json
      expect(response).to have_http_status(404)
    end
  end

  describe "retieve specific application" do
    it "returns 200, retrieved the application successfully" do 
      get application_path token:@application.token
      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(parsed_response['name']).to eq(@application.name)
      expect(parsed_response['token']).to eq(@application.token)

    end

    it "returns 404, application is not exist" do 
      get application_path token:'invalidToken'
      expect(response).to have_http_status(404)
    end
  end

  describe "delete application" do 
    it "returns 204, delete the application successfully" do 
      delete application_path token:@application.token
      expect(response).to have_http_status(204)
    end

    it "returns 404, application is not exist" do 
      delete application_path token:"InvalidToken"
      expect(response).to have_http_status(404)
    end
  end

  describe "chats count" do 
    it "returns 200, application has chats" do
      get application_chats_count_path application_token:@application.token

      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(parsed_response['count']).to eq(@application.chats.count)
    end

    it "returns 200, application has not chats" do 
      get application_chats_count_path application_token:@application_2.token

      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(parsed_response['count']).to eq(@application_2.chats.size)
    end
  end
end
