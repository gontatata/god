Rails.application.routes.draw do
  root "deme#index"
  post "/deme/search", to: "deme#search", as: "deme_search"
end
