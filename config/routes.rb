Rails.application.routes.draw do
  scope module: :api, path: :api do
    scope module: :v1, path: :v1 do
      resources :disbursements, only: %i[index]
    end
  end
end
