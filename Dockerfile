# Use Ruby 3.2 as the base image
FROM ruby:3.2

# Set the working directory
WORKDIR /usr/src/app

# Ensure a clean installation of dependencies
RUN bundle config set --local clean true
RUN bundle config set --local path 'vendor/bundle'

# Copy the Gemfile and Gemfile.lock first for dependency installation
COPY Gemfile Gemfile.lock ./

# Install the gems
RUN bundle install --no-cache

# Copy the rest of the application
COPY . .

# Expose port 5200
EXPOSE 5200

# Run the application
CMD ["ruby", "app.rb", "-o", "0.0.0.0", "-p", "5200"]
