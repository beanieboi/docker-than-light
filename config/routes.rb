Rails.application.routes.draw do
  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/sign_out', to: 'sessions#destroy'
  
  namespace :api do
    post  'spawn'           => 'api#spawn'
    post  'fire/:name'      => 'api#fire'
    get   'scan'            => 'api#scan'
    get   'scan/:name'      => 'api#scan_ship'
    post  'upgrade/type'    => 'api#upgrade'
    get   'sectors'         => 'api#sectors'
    post  'travel/:sector'  => 'api#travel'

    get   'logs/:ship_name' => 'logs#show', as: :ship_log
  end

  scope module: 'application' do
    resource :dashboard, only: [:show]
  end

  root 'website/welcome#index'
end
