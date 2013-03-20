Burp::Engine.routes.draw do
  get "/" => "static#index"
  get "/help" => "static#help"
  
  resources :files
  get "/files/" => "files#index"
  post "/files/" => "files#create"
  get "/files/*id" => "files#show"
  delete "/files/*id" => "files#destroy"
  
  resources :pages
  get "/pages/*id/edit" => "pages#edit", :id => /.+/
  get "/pages/*id" => "pages#show", :id => /.+/
  put "/pages/*id" => "pages#update", :id => /.+/
  delete "/pages/*id" => "pages#destroy", :id => /.+/
  
  resources :menus do
    resources :groups
    resources :links
  end
  
  # Catch all to 404 error
  match "/*path" => "error#no_such_page"

end

Rails.application.routes.draw do
  mount Burp::Engine => "/burp"
  match '/:path' => 'burp::catch_all#show', :constraints => { :path => /.*/ }
end
