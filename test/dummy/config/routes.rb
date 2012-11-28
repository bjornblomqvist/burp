Rails.application.routes.draw do

  mount Burp::Engine => "/burp"
  match '/:path' => 'burp::catch_all#show', :constraints => { :path => /.*/ }
end
  