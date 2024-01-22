Rails.application.routes.draw do
  resources :urls, only: [:create]
  get '/urls/:short_url', param: :short_url, to: 'urls#show', as: 'short_url'
  get '/urls/:short_url/stats', param: :short_url, to: 'urls#stats', as: 'url_stats'
end
