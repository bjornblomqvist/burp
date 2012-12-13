Burp::Engine.routes.draw do
  get "/" => "static#index"
  
  resources :files
  get "/files/" => "files#index"
  post "/files/" => "files#create"
  get "/files/*id" => "files#show"
  delete "/files/*id" => "files#destroy"
  
  resources :pages
  get "/pages/*id/edit" => "pages#edit"
  get "/pages/*id" => "pages#show"
  put "/pages/*id" => "pages#update"
  
  resources :menus do
    resources :groups
    resources :links
  end
  
  # Catch all to 404 error
  match "/*path" => "error#no_such_page"

end
