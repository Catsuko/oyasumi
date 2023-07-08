RSpec.shared_context 'json request' do
  let(:json_response) { JSON.parse(response.body) }
end

RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers, type: :request
  config.include_context 'json request', type: :request
end
