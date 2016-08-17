require 'resque/server'

Rails.application.routes.draw do

  mount Resque::Server.new, at: "/resque"

  get 'final_policy_group_rating_and_premium_projections/index'

  resources :import do
    collection { delete :destroy }
  end

  resources :parse do
    collection { delete :destroy}
  end

  resources :group_ratings

  resources :final_policy_group_rating_and_premium_projections

  resources :democ_detail_records do
     collection { post :parse }
     collection { delete :destroy}
  end

  resources :mremp_employer_experience do
     collection { post :parse }
     collection { delete :destroy}
  end

  resources :mrcl_detail_records do
     collection { post :parse }
     collection { delete :destroy}
  end

  resources :pcomb_detail_records do
     collection { post :parse }
     collection { delete :destroy}
  end

  resources :phmgn_detail_records do
     collection { post :parse }
     collection { delete :destroy}
  end

  resources :sc220_employer_demographics do
     collection { post :parse }
     collection { delete :destroy}
  end

  resources :sc230_employer_demographics do
     collection { post :parse }
     collection { delete :destroy}
  end


  resources :welcome

  root 'welcome#index'

end
