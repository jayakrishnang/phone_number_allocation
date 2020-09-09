# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper scope: 'api/v1' do
    skip_controllers :authorizations, :applications, :authorized_applications
  end

  scope module: :api, defaults: { format: :json }, path: 'api/v1' do
    scope module: :v1 do
      devise_for :users, controllers: {
        registrations: 'api/v1/users/registrations'
      }, skip: [:sessions, :password]

      resources :users, only: [:show] do
        post :allocate_phone_number, on: :collection
        get :me, on: :collection
      end

      resources :phone_numbers, only: [:index]
    end
  end
end
