require "test_helper"

class InvestmentsControllerTest < ActionDispatch::IntegrationTest
  test 'should get calculate_investment' do
    get calculate_investment_path
    assert_response :success
  end

  test 'should render calculate_investment template' do
    get calculate_investment_path
    assert_template 'calculate_investment'
  end

  test 'should render data_result partial on valid POST request' do
    post calculate_investment_path, params: { balance: 100, bitcoin_investment: 50, ether_investment: 30, cardano_investment: 20 }
    assert_response :success
    assert_template partial: '_data_result'
  end

  test 'should export CSV file' do
    post export_csv_investments_path, params: { balance: 100, bitcoin_investment: 50, ether_investment: 30, cardano_investment: 20 }
    assert_response :success
    assert_equal 'text/csv', response.content_type
    assert_match(/attachment; filename=.+\.csv/, response.headers['Content-Disposition'])
  end

  test 'should export JSON file' do
    post export_json_investments_path, params: { balance: 100, bitcoin_investment: 50, ether_investment: 30, cardano_investment: 20 }
    assert_response :success
    assert_equal 'application/json', response.content_type
    assert_match(/attachment; filename=.+\.json/, response.headers['Content-Disposition'])
  end
end
