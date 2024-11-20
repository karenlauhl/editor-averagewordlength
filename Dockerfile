# Use Ruby 3.2 as the base image
FROM ruby:3.2

# Define the port number as an environment variable
ENV PORT=5200

# Set the working directory
WORKDIR /usr/src/app

# Install the correct version of bundler
RUN gem install bundler -v 2.5.23

# Copy the Gemfile and Gemfile.lock first for dependency installation
COPY Gemfile Gemfile.lock ./

# Install the gems
RUN bundle install

# Copy the rest of the application
COPY . .

# Expose the port defined by the environment variable
EXPOSE $PORT

# Run the application
CMD ["ruby", "app.rb", "-o", "0.0.0.0", "-p", "$PORT"]
