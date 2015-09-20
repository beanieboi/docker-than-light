Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  post  'spawn'           => 'api#spawn'
  post  'fire/:ip'        => 'api#fire'
  get   'scan'            => 'api#scan'
  get   'scan/:ip'        => 'api#scan_ip'
  post  'upgrade/type'    => 'api#upgrade'
  get   'sectors'         => 'api#sectors'
  post  'travel/:sector'  => 'api#travel'

  get   'logs/:ship_name' => 'logs#show'

  root 'welcome#index'
end
