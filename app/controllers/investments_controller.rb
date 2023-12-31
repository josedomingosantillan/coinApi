# app/controllers/investments_controller.rb
class InvestmentsController < ApplicationController
  before_action :set_coinapi_service

  def calculate_investment
    if request.post?
      params[:balance] = 0 unless params[:balance].present?
      params[:bitcoin_investment] = 0 unless params[:bitcoin_investment].present?
      params[:ether_investment] = 0 unless params[:ether_investment].present?
      params[:cardano_investment] = 0 unless params[:cardano_investment].present?

      balance = params[:balance].to_i
      bitcoin_investment = params[:bitcoin_investment].to_i
      ether_investment = params[:ether_investment].to_i
      cardano_investment = params[:cardano_investment].to_i
      if balance > 0 && bitcoin_investment > 0 && ether_investment > 0 && cardano_investment > 0
        @cryptocurrency_data = obtener_datos_criptomonedas(balance, bitcoin_investment, ether_investment, cardano_investment)
        @balance = balance
        @bitcoin_investment = bitcoin_investment
        @ether_investment = ether_investment
        @cardano_investment = cardano_investment
        render partial: 'data_result'
        return
      end
    end
    render 'calculate_investment'
  end

  def export_csv
    respond_to do |format|
      format.csv do
        send_data generate_csv(params[:balance].to_i, params[:bitcoin_investment].to_i, params[:ether_investment].to_i, params[:cardano_investment].to_i), filename: "cryptocurrency_data_#{Time.now.strftime('%Y%m%d%H%M%S')}.csv"
      end
    end
  end

  def export_json
    data = obtener_datos_criptomonedas(params[:balance].to_i, params[:bitcoin_investment].to_i, params[:ether_investment].to_i, params[:cardano_investment].to_i)
    json_data = data.to_json

    respond_to do |format|
      format.json do
        send_data json_data, filename: "cryptocurrency_data_#{Time.now.strftime('%Y%m%d%H%M%S')}.json"
      end
    end
  end

  private

  def set_coinapi_service
    api_key = 'bd5570c4-4a1e-46d7-bd4a-176f0dae6a5b'
    @coinapi_service = CoinapiService.new(api_key)
  end

  def generate_csv(balance, bitcoin_investment, ether_investment, cardano_investment)
    data = obtener_datos_criptomonedas(balance, bitcoin_investment, ether_investment, cardano_investment)
    CSV.generate(headers: true) do |csv|
      csv << ['Criptomoneda', 'Precio (USD)', 'Ganancia en USD por año']
      data.each do |row|
        csv << [row['name'], row['price'], row['profit_per_year']]
      end
    end
  end

  def obtener_datos_criptomonedas(balance, bitcoin_investment, ether_investment, cardano_investment)
    bitcoin_data = @coinapi_service.cryptocurrency_data('BTC')
    ether_data = @coinapi_service.cryptocurrency_data('ETH')
    cardano_data = @coinapi_service.cryptocurrency_data('ADA')

    [
      { 'name' => 'Bitcoin', 'price' => bitcoin_data['rate'], 'profit_per_year' => profit_per_year(bitcoin_data['rate'].to_i, bitcoin_investment, 0.05) },
      { 'name' => 'Ether', 'price' => ether_data['rate'], 'profit_per_year' => profit_per_year(ether_data['rate'].to_i, ether_investment, 0.042) },
      { 'name' => 'Cardano', 'price' => cardano_data['rate'], 'profit_per_year' => profit_per_year(cardano_data['rate'].to_i, cardano_investment, 0.01) }
    ]
  end

  def profit_per_year(rate, investment, monthly_return)
    tasa_mensual = monthly_return / 100.0
    tasa_anual = (1 + tasa_mensual) ** 12 - 1

    ganancia_anual = rate * tasa_anual * investment
    ganancia_anual.round(8)
  end

  def user_params
    params.require(:user).permit(:balance, :bitcoin_investment, :ether_investment, :cardano_investment)
  end
end
