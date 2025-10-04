# Helper methods for API testing
module ApiHelpers
  # Parse JSON response
  def json_response
    @json_response ||= JSON.parse(response.body, symbolize_names: true)
  end

  # Helper to set JSON headers
  def json_headers
    {
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }
  end

  # Helper to make JSON POST requests
  def post_json(path, params = {})
    post path, params: params.to_json, headers: json_headers
  end

  # Helper to make JSON PUT requests
  def put_json(path, params = {})
    put path, params: params.to_json, headers: json_headers
  end

  # Helper to make JSON PATCH requests
  def patch_json(path, params = {})
    patch path, params: params.to_json, headers: json_headers
  end

  # Check if response has the expected structure
  def expect_json_response(expected_keys)
    expect(response.content_type).to include('application/json')
    expect(json_response).to include(*expected_keys)
  end

  # Check for successful API response
  def expect_successful_json_response(status = :ok)
    expect(response).to have_http_status(status)
    expect(response.content_type).to include('application/json')
  end

  # Authentication helper for testing
  def sign_in(user, password = "password123456")
    post "/sign_in", params: {
      email: user.email,
      password: password
    }

    if response.successful?
      token = response.headers["X-Session-Token"]
      return user, token
    else
      raise "Sign in failed: #{response.body}"
    end
  end

  # Sign out helper for testing
  def sign_out(token)
    delete "/sign_out", headers: auth_headers(token)

    # Clear any cached response data
    @json_response = nil

    # Clear authentication state
    clear_auth_state

    response.successful?
  end

  # Sign out specific session helper for testing
  def sign_out_session(session_id, token)
    delete "/sessions/#{session_id}", headers: auth_headers(token)

    # Clear any cached response data
    @json_response = nil

    response.successful?
  end

  # Helper to create authorization headers
  def auth_headers(token)
    {
      "Authorization" => "Bearer #{token}"
    }
  end

  # Clear authentication state in tests
  def clear_auth_state
    @json_response = nil
    # Clear any test-specific Current state if needed
    Current.user = nil
    Current.session = nil
  end
end
