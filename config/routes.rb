Burp::Engine.routes.draw do
  get "/" => "static#index"

  get "/files/" => "file#index"
  post "/files/" => "file#create"
  get "/files/*id" => "file#show"
  
  resources :pages
  get "/pages/*id/edit" => "pages#edit"
  put "/pages/*id" => "pages#update"
  
  resources :menus do
    resources :groups
    resources :links
  end
  
  # Catch all to 404 error
  match "/*path" => "error#no_such_page"

end
