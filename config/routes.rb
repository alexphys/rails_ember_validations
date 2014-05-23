Rails.application.routes.draw do
  post '/validate', to: 'validations#validate', as: 'validate'
end