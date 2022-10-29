Rails.application.routes.draw do
  scope :api do
    use_doorkeeper do
      skip_controllers :authorizations, :applications, :authorized_applications
    end
    resource :user, only: [:create, :update]
  end
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
