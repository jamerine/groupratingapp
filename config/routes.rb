Rails.application.routes.draw do

  resources :import do
    collection { delete :destroy }
  end

  resources :parse do
    collection { delete :destroy}
  end

  resources :group_ratings

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
