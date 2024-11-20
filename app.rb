require 'sinatra'
require 'json'

# Allow all hosts in all environments
configure do
  set :bind, '0.0.0.0'   # Allow external access
  set :port, 5200        # Default port for the application
  set :protection, except: :http_origin # Allow cross-origin requests
  set :allowed_hosts, nil               # Ensure all hosts are allowed
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

    # Validate input
    if !input["text"] || input["text"].strip.empty?
      halt 400, { error: "Input text cannot be empty" }.to_json
    end

    text = input["text"]
    words = text.scan(/\b\w+\b/)
    total_length = words.map(&:length).sum
    average_length = words.empty? ? 0 : (total_length.to_f / words.size)

    # Return result as JSON
    { average_word_length: average_length.round(2) }.to_json
  rescue JSON::ParserError
    halt 400, { error: "Invalid JSON format" }.to_json
  end
end
