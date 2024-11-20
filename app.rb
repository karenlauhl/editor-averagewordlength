require 'sinatra'
require 'json'

# Disable Host Authorization and all protection mechanisms
set :bind, '0.0.0.0'
set :port, 5200
set :protection, except: :http_host # Explicitly disable host protection
disable :protection

before do
  puts "Incoming Host: #{request.host}"
end


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
