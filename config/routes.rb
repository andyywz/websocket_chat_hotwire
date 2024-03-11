Rails.application.routes.draw do
  use_doorkeeper

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords",
  }

  resources :users, only: [:index, :show, :edit, :update]
  resources :dance_events do
    resources :dance_event_participants, only: [:new] do
      collection do
        get :upload
        post :import
      end
    end
  end

  resources :dance_event_participants, only: [:create, :destroy]

  root "dance_events#index"
end
