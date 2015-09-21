Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  post  'spawn'           => 'api#spawn'
  post  'fire/:name'      => 'api#fire'
  get   'scan'            => 'api#scan'
  get   'scan/:name'      => 'api#scan_ship'
  post  'upgrade/type'    => 'api#upgrade'
  get   'sectors'         => 'api#sectors'
  post  'travel/:sector'  => 'api#travel'

  get   'logs/:ship_name' => 'logs#show', as: :ship_log

  root 'welcome#index'
end
