Rails.application.routes.draw do




  resources :import do
    collection { delete :destroy }
  end

  resources :parse do
    collection { delete :destroy}
  end

  resources :democ_detail_records do
     collection { post :parse }
  end

  resources :mremp_employer_experience do
     collection { post :parse }
  end

  resources :mrcl_detail_records do
     collection { post :parse }
  end

  resources :pcomb_detail_records do
     collection { post :parse }
  end

  resources :phmgn_detail_records do
     collection { post :parse }
  end

  resources :sc220_employer_demographics do
     collection { post :parse }
  end

  resources :sc230_employer_demographics do
     collection { post :parse }
  end

  resources :group_rating
  
  resources :welcome

  root 'welcome#index'

end
