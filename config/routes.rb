Rails.application.routes.draw do
  use_doorkeeper

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords",
  }

  resources :users, only: [:index, :show, :edit, :update]
  resources :dance_events do
    resources :dance_event_participants, only: [:new]
  end

  resources :dance_event_participants, only: [:create]

  root "dance_events#index"
end
