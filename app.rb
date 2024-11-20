require 'sinatra'
require 'json'

# Allow all hosts in all environments
set :bind, '0.0.0.0'
set :port, 5200
set :protection, except: :http_origin # Allow cross-origin requests
disable :protection                    # Disable additional protection

# Default route: Accepts 'text' as a query parameter
get '/' do
  content_type :json

  # Extract 'text' query parameter
  text = params['text']

  # Validate input
  if text.nil? || text.strip.empty?
    halt 400, { error: "Query parameter 'text' cannot be empty" }.to_json
  end

  # Calculate average word length
  words = text.scan(/\b\w+\b/)
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
    words = text.scan(/\b\w+\b/)
    total_length = words.map(&:length).sum
    average_length = words.empty? ? 0 : (total_length.to_f / words.size)

    # Return JSON response
    { average_word_length: average_length.round(2) }.to_json
  rescue JSON::ParserError
    halt 400, { error: "Invalid JSON format" }.to_json
  end
end
