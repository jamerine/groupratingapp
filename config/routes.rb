Rails.application.routes.draw do

  resources :import do
    collection { delete :destroy }
  end

  resources :parse do
    collection { delete :destroy}
  end

  resources :welcome

  root 'welcome#index'

end
