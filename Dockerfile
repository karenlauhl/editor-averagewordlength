# Use Ruby 3.2 as the base image
FROM ruby:3.2

# Set the working directory
WORKDIR /usr/src/app

# Copy the Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install the gems
RUN bundle install

# Copy the rest of the application
COPY . .

# Expose port 5200
EXPOSE 5200

# Run the application
CMD ["ruby", "app.rb", "-o", "0.0.0.0", "-p", "5200"]
