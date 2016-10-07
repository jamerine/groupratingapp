require 'sidekiq/web'



Rails.application.routes.draw do



  # mount Resque::Server.new, at: "/resque"
  # ...
  mount Sidekiq::Web, at: '/sidekiq'

  devise_for :users

  resources :accounts do
    post :group_rating_calc
  end

  resources :imports do
    collection { delete :destroy }
  end

  resources :parse do
    collection { delete :destroy}
  end

  resources :group_ratings

  resources :payroll_calculations

  resources :claim_calculations

  resources :final_policy_group_rating_and_premium_projections

  resources :policy_calculations do
    collection {get 'create_policy_objects'}

  end

  resources :representatives do
    post :fee_calculations
    get :export_manual_classes
  end


  resources :manual_class_calculations do
    collection {get 'create_manual_class_objects'}
  end

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
