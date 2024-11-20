require 'sinatra'
require 'json'

# Allow all hosts and disable protection
set :bind, '0.0.0.0'
set :port, 5200
disable :protection # Disable Rack::Protection middleware

# Default route
get '/' do
  content_type :json

  # Check if 'text' query parameter is provided
  unless params.key?('text')
    halt 400, { error: "Query parameter 'text' is missing" }.to_json
  end

  text = params['text']

  # Validate input
  if text.strip.empty?
    halt 400, { error: "Query parameter 'text' cannot be empty" }.to_json
  end

  # Exclude numbers and calculate average word length
  words = text.scan(/\b[a-zA-Z]+\b/) # Match only alphabetic words
  total_length = words.map(&:length).sum
  average_length = words.empty? ? 0 : (total_length.to_f / words.size)

  # Return JSON response
  { text: text, average_word_length: average_length.round(2) }.to_json
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

    # Exclude numbers and calculate average word length
    words = text.scan(/\b[a-zA-Z]+\b/) # Match only alphabetic words
    total_length = words.map(&:length).sum
    average_length = words.empty? ? 0 : (total_length.to_f / words.size)

    # Return JSON response
    { average_word_length: average_length.round(2) }.to_json
  rescue JSON::ParserError
    halt 400, { error: "Invalid JSON format" }.to_json
  end
end
