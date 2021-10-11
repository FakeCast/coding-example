# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :vacation_request, only: %i[index create show] do
        member do
          put :approve
          put :reject
        end
      end
    end
  end
end
