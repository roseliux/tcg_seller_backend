# TCG Marketplace - Backend API

A Ruby on Rails API-only application for a Trading Card Game (TCG) marketplace. This backend serves as the foundation for both mobile (React Native) and web (React) clients.

## 🚀 Tech Stack

- **Ruby**: 3.4.5
- **Rails**: 8.0.3 (API-only mode)
- **Database**: PostgreSQL 15
- **JSON Serialization**: Jbuilder
- **Web Server**: Puma
- **CORS**: Rack-CORS for cross-origin requests

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- Ruby 3.4.5 (recommended via rbenv)
- PostgreSQL 15+
- Bundler gem
- Git

## 🛠️ Installation & Setup

### 1. Clone the repository
```bash
git clone https://github.com/roseliux/tcg_seller_backend.git
cd tcg_seller_backend
```

### 2. Install Ruby dependencies
```bash
bundle install
```

### 3. Database setup
```bash
# Create the databases
rails db:create

# Run migrations (when available)
rails db:migrate

# Seed the database (optional)
rails db:seed
```

### 4. Start the development server
```bash
rails server
```

The API will be available at `http://localhost:3000`

## 🗄️ Database Configuration

This application uses PostgreSQL with the following database names:
- **Development**: `tcg_seller_development`
- **Test**: `tcg_seller_test`
- **Production**: `tcg_seller_production` (with cache, queue, and cable databases)

### Environment Variables

You can configure database connection using these environment variables:
- `DATABASE_USERNAME`: Database user (defaults to system user)
- `DATABASE_PASSWORD`: Database password
- `DATABASE_HOST`: Database host (defaults to localhost)
- `DATABASE_PORT`: Database port (defaults to 5432)

## 🧪 Testing

Run the test suite with:
```bash
# Run all tests
rails test

# Run specific test file
rails test test/models/example_test.rb
```

## 📡 API Endpoints

The API uses JSON format for all requests and responses. CORS is configured to allow cross-origin requests for mobile and web clients.

### Example API Response Format (using Jbuilder)
```json
{
  "id": 1,
  "name": "Card Name",
  "description": "Card description",
  "price": "10.99"
}
```

## 🚢 Deployment

This application is configured for deployment with Kamal. The Docker configuration and deployment settings are included.

### Docker
The application includes a `Dockerfile` for containerized deployment.

### Production Environment
Ensure the following environment variables are set in production:
- `DATABASE_USERNAME`
- `DATABASE_PASSWORD`
- `DATABASE_HOST`
- `DATABASE_PORT`
- `RAILS_MASTER_KEY` (for credentials)

## 🔧 Development

### Code Quality
- **Brakeman**: Security vulnerability scanning
- **RuboCop**: Ruby style guide enforcement (Rails Omakase configuration)

### Debugging
The `debug` gem is available in development and test environments for debugging.

## 📁 Project Structure

```
app/
├── controllers/          # API controllers
├── models/              # Active Record models
├── views/               # Jbuilder JSON templates
└── jobs/                # Background jobs

config/
├── routes.rb            # API routes
├── database.yml         # Database configuration
└── initializers/
    └── cors.rb          # CORS configuration

db/
├── migrate/             # Database migrations
└── seeds.rb            # Database seeds

test/                    # Test files
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is private and proprietary.

## 🎯 Roadmap

- [ ] User authentication (JWT)
- [ ] Card management API
- [ ] Listing management API
- [ ] User profiles
- [ ] Search and filtering
- [ ] Image upload support
- [ ] Payment integration
- [ ] Real-time notifications

## 📞 Support

For questions or support, please open an issue in the repository.
