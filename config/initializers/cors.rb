# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    if Rails.env.development?
      # Allow local development (covers localhost, 127.0.0.1, and local network IPs)
      origins(/\Ahttp:\/\/(localhost|127\.0\.0\.1|\d+\.\d+\.\d+\.\d+):\d+\z/)
    else
      # Production origins - replace with your actual domains
      origins "https://your-production-domain.com"
    end

    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      expose: ["X-Session-Token"] # Expose custom headers to the client
  end
end
