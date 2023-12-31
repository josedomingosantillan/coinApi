require 'rails_helper'
require 'webmock/rspec'

RSpec.describe CoinapiService, type: :service do
  let(:api_key) { 'bd5570c4-4a1e-46d7-bd4a-176f0dae6a5b' }
  let(:service) { CoinapiService.new(api_key) }

  before do
    base_uri = 'https://rest.coinapi.io'
    stub_request(:get, "#{base_uri}/v1/exchangerate/BTC/USD")
      .with(headers: { 'X-CoinAPI-Key' => api_key, 'Accept' => 'text/json' })
      .to_return(body: '{"rate": 50000}', headers: { 'Content-Type' => 'text/json' })
  end

  describe '#cryptocurrency_data' do
    it 'returns cryptocurrency data' do
      symbol = 'BTC'
      response = service.cryptocurrency_data(symbol)

      expect(response.code).to eq(200)
      expect(response['rate']).to eq(50000)
    end
  end
end
