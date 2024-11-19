require './app'
require 'rack/test'
require 'rspec'

describe 'Average Word Length API' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "returns Hello World for the root route" do
    get '/', {}, { 'HTTP_HOST' => 'localhost' } # Explicitly set the Host header
    expect(last_response).to be_ok
    expect(last_response.body).to eq("Hello World! Your Sinatra app is running!")
  end

  it "calculates the average word length" do
    post '/average_word_length', { text: "Hello world" }.to_json, { "CONTENT_TYPE" => "application/json", 'HTTP_HOST' => 'localhost' }
    expect(last_response).to be_ok
    expect(JSON.parse(last_response.body)["average_word_length"]).to eq(5.0)
  end

  it "returns an error for empty text input" do
    post '/average_word_length', { text: "" }.to_json, { "CONTENT_TYPE" => "application/json", 'HTTP_HOST' => 'localhost' }
    expect(last_response.status).to eq(400)
    expect(JSON.parse(last_response.body)).to eq({ "error" => "Input text cannot be empty" })
  end

    it "returns an error for invalid JSON format" do
    post '/average_word_length', "invalid json", { "CONTENT_TYPE" => "application/json", 'HTTP_HOST' => 'localhost' }
    expect(last_response.status).to eq(400)
    expect(JSON.parse(last_response.body)).to eq({ "error" => "Invalid JSON format" })
  end

    it "returns an error for missing text key" do
    post '/average_word_length', { invalid_key: "Hello world" }.to_json, { "CONTENT_TYPE" => "application/json", 'HTTP_HOST' => 'localhost' }
    expect(last_response.status).to eq(400)
    expect(JSON.parse(last_response.body)).to eq({ "error" => "Input text cannot be empty" })
  end

    it "returns an error for missing text value" do
    post '/average_word_length', { text: nil }.to_json, { "CONTENT_TYPE" => "application/json", 'HTTP_HOST' => 'localhost' }
    expect(last_response.status).to eq(400)
    expect(JSON.parse(last_response.body)).to eq({ "error" => "Input text cannot be empty" })
  end

    it "returns an error for missing JSON body" do
    post '/average_word_length', nil, { "CONTENT_TYPE" => "application/json", 'HTTP_HOST' => 'localhost' }
    expect(last_response.status).to eq(400)
    expect(JSON.parse(last_response.body)).to eq({ "error" => "Invalid JSON format" })
  end

    it "returns an error for invalid JSON format" do
    post '/average_word_length', "invalid json", { "CONTENT_TYPE" => "application/json", 'HTTP_HOST' => 'localhost' }
    expect(last_response.status).to eq(400)
    expect(JSON.parse(last_response.body)).to eq({ "error" => "Invalid JSON format" })
  end

end
