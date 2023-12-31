# app/services/coinapi_service.rb
class CoinapiService
  include HTTParty

  def initialize(api_key)
    @options = { headers: { 'X-CoinAPI-Key' => api_key , 'Accept' => 'text/json'} }
  end

  def cryptocurrency_data(symbol)
    self.class.base_uri 'https://rest.coinapi.io'
    self.class.get("/v1/exchangerate/#{symbol}/USD", @options)
  end
end
