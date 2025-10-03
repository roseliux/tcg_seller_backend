require 'rails_helper'

RSpec.describe 'Application', type: :request do
  describe 'GET /health' do
    context 'when checking application health' do
      before { get '/health' }

      it_behaves_like 'returns successful response'

      it 'returns health status' do
        expect(json_response).to include(
          status: 'ok',
          timestamp: be_present
        )
      end
    end
  end
end
