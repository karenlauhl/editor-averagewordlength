require 'rack/test'  # Rack::Test provides testing utilities for Sinatra/Rack
require 'rspec'      # RSpec core library
require './app'      # Load your Sinatra app

# Set Sinatra environment to test mode
ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  config.include Rack::Test::Methods # Include Rack::Test methods in specs

  # Define the Sinatra app for Rack::Test
  def app
    Sinatra::Application
  end
end
