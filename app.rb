require 'sinatra'
require 'json'

# Server configuration
set :bind, '0.0.0.0'
set :port, 5200
disable :protection

# Log incoming requests for debugging
before do
  puts "Incoming Request: #{request.request_method} #{request.path_info}"
end

# Default GET route for calculating average word length via query parameter
get '/' do
  content_type :json

  unless params.key?('text')
    halt 400, { error: "Query parameter 'text' is missing" }.to_json
  end

  text = params['text']

  if text.strip.empty?
    halt 400, { error: "Query parameter 'text' cannot be empty" }.to_json
  end

  # Exclude numbers and calculate average word length
  words = text.scan(/\b[a-zA-Z]+\b/) # Match only alphabetic words
  total_length = words.map(&:length).sum
  average_length = words.empty? ? 0 : (total_length.to_f / words.size)

  { text: text, average_word_length: average_length.round(2) }.to_json
end

# POST route for JSON-based input
post '/average_word_length' do
  content_type :json

  begin
    request_body = request.body.read
    input = JSON.parse(request_body)

    if !input["text"] || input["text"].strip.empty?
      halt 400, { error: "Input text cannot be empty" }.to_json
    end

    text = input["text"]

    # Exclude numbers and calculate average word length
    words = text.scan(/\b[a-zA-Z]+\b/)
    total_length = words.map(&:length).sum
    average_length = words.empty? ? 0 : (total_length.to_f / words.size)

    { average_word_length: average_length.round(2) }.to_json
  rescue JSON::ParserError
    halt 400, { error: "Invalid JSON format" }.to_json
  end
end

# Fallback for undefined routes
not_found do
  content_type :json
  { error: "Endpoint not found" }.to_json
end
