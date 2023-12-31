Rails.application.routes.draw do
  match '/calculate_investment', to: 'investments#calculate_investment', via: [:get, :post]

  resources :investments do

      post 'export_csv', on: :collection, defaults: { format: :csv }
      post 'export_json', on: :collection, defaults: { format: :json }

  end

  root :to=> 'investments#calculate_investment'

  mount ActionCable.server => '/cable'
end
