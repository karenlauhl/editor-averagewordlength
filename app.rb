require 'sinatra'
require 'json'

# Allow all hosts in the test environment
configure :test do
  disable :protection  # Disable all Rack protection
  set :allowed_hosts, nil # Ensure all hosts are allowed
end

# Default route
get '/' do
  "Hello World! Your Sinatra app is running!"
end

# POST route for calculating average word length
post '/average_word_length' do
  content_type :json

  begin
    request_body = request.body.read
    input = JSON.parse(request_body)

    if !input["text"] || input["text"].empty?
      halt 400, { error: "Input text cannot be empty" }.to_json
    end

    text = input["text"]
    words = text.scan(/\b\w+\b/)
    total_length = words.map(&:length).sum
    average_length = words.empty? ? 0 : (total_length.to_f / words.size)

    { average_word_length: average_length.round(2) }.to_json
  rescue JSON::ParserError
    halt 400, { error: "Invalid JSON format" }.to_json
  end
end
