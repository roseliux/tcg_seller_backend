# Shared examples for API testing
RSpec.shared_examples 'an API endpoint' do
  it 'returns JSON content type' do
    expect(response.content_type).to include('application/json')
  end
end

RSpec.shared_examples 'returns successful response' do |status = :ok|
  it "returns #{status} status" do
    expect(response).to have_http_status(status)
  end

  it 'returns JSON content type' do
    expect(response.content_type).to include('application/json')
  end
end

RSpec.shared_examples 'returns error response' do |status, message = nil|
  it "returns #{status} status" do
    expect(response).to have_http_status(status)
  end

  it 'returns JSON content type' do
    expect(response.content_type).to include('application/json')
  end

  if message
    it "returns error message containing '#{message}'" do
      expect(json_response[:error]).to include(message)
    end
  end
end

RSpec.shared_examples 'validates required parameters' do |required_params|
  required_params.each do |param|
    context "when #{param} is missing" do
      let(:invalid_params) { valid_params.except(param) }

      it 'returns unprocessable entity status' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
