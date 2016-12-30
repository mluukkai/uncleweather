Rails.application.routes.draw do
  root 'weather#index'

  get '/sms', to: 'weather#sms'
end
