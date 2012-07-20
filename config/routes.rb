Burp::Engine.routes.draw do
  get "/" => "static#index"
  
  get "/pages/" => "page#index"
  get "/pages/new" => "page#new"
  post "/pages/create" => "page#create"
  get "/pages/*id/edit" => "page#edit"
  post "/pages/*id/update" => "page#update"
  delete "/pages/*id/" => "page#destroy"
  
  get "/files/" => "file#index"
  post "/files/" => "file#create"

end
