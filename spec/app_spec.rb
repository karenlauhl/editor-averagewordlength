require './app'
require 'rack/test'
require 'rspec'

describe 'Average Word Length API' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  # Test root route with query parameters
  describe 'GET /' do
    it "calculates the average word length from query parameter excluding numbers" do
      get '/', { text: "The quick brown fox 123 jumps 456 over 789 lazy dogs" }, { 'HTTP_HOST' => 'localhost' }
      expect(last_response).to be_ok
      response_body = JSON.parse(last_response.body)
      expect(response_body["text"]).to eq("The quick brown fox 123 jumps 456 over 789 lazy dogs")
      expect(response_body["average_word_length"]).to eq(4.13) # Numbers are excluded
    end

    it "returns a 400 error if text query parameter is empty" do
      get '/', { text: "" }, { 'HTTP_HOST' => 'localhost' }
      expect(last_response.status).to eq(400)
      response_body = JSON.parse(last_response.body)
      expect(response_body).to eq({ "error" => "Query parameter 'text' cannot be empty" })
    end

    it "returns a 400 error if text query parameter is missing" do
      get '/', {}, { 'HTTP_HOST' => 'localhost' }
      expect(last_response.status).to eq(400)
      response_body = JSON.parse(last_response.body)
      expect(response_body).to eq({ "error" => "Query parameter 'text' is missing" })
    end

    it "returns a 400 error if text query parameter is not provided" do
      get '/', { invalid: "invalid" }, { 'HTTP_HOST' => 'localhost' }
      expect(last_response.status).to eq(400)
      response_body = JSON.parse(last_response.body)
      expect(response_body).to eq({ "error" => "Query parameter 'text' is missing" })
    end

  end

  # Test POST /average_word_length
  describe 'POST /average_word_length' do
    it "calculates the average word length excluding numbers" do
      post '/average_word_length', { text: "Hello world 12345" }.to_json, { "CONTENT_TYPE" => "application/json", 'HTTP_HOST' => 'localhost' }
      expect(last_response).to be_ok
      response_body = JSON.parse(last_response.body)
      expect(response_body["average_word_length"]).to eq(5.0) # "12345" is excluded
    end

    it "returns an error for empty text input in POST request" do
      post '/average_word_length', { text: "" }.to_json, { "CONTENT_TYPE" => "application/json", 'HTTP_HOST' => 'localhost' }
      expect(last_response.status).to eq(400)
      response_body = JSON.parse(last_response.body)
      expect(response_body).to eq({ "error" => "Input text cannot be empty" })
    end

    it "returns an error for invalid JSON format in POST request" do
      post '/average_word_length', "invalid json", { "CONTENT_TYPE" => "application/json", 'HTTP_HOST' => 'localhost' }
      expect(last_response.status).to eq(400)
      response_body = JSON.parse(last_response.body)
      expect(response_body).to eq({ "error" => "Invalid JSON format" })
    end

    it "returns an error for missing text input in POST request" do
      post '/average_word_length', { invalid: "invalid" }.to_json, { "CONTENT_TYPE" => "application/json", 'HTTP_HOST' => 'localhost' }
      expect(last_response.status).to eq(400)
      response_body = JSON.parse(last_response.body)
      expect(response_body).to eq({ "error" => "Input text cannot be empty" })
    end

    
  end
end
