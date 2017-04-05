require 'sidekiq/web'

Rails.application.routes.draw do

  mount Sidekiq::Web, at: '/sidekiq'

  devise_for :users, controllers: {
        sessions: 'users/sessions',
        confirmations: 'users/confirmations',
        registrations: 'users/registrations',
      }

  resources :users, except: :create

  post 'create_user' => 'users#create', as: :create_user

  resources :accounts do
    get :edit_group_rating
    get :edit_group_retro
    post :group_rating_calc
    post :group_retro_calc
    post :group_rating
    post :assign
    post :assign_address
    collection { post :import_account_process }
    get :risk_report
    get :roc_report
  end

  resources :affiliates do
    collection { get :import_affiliate_process }
  end


  resources :contacts do
    collection { post :import_contact_process }
  end


  resources :quotes do
    get :group_rating_report
    collection { post :quote_accounts }
    collection { delete :delete_all_quotes }
    get :view_group_rating_quote
    get :view_invoice

  end

  resources :account_programs do
    collection { post :import_account_program_process }
  end

  resources :imports do
    collection { delete :destroy }
  end

  resources :parse do
    collection { delete :destroy}
  end

  resources :representatives_users

  resources :group_ratings

  resources :payroll_calculations

  resources :claim_calculations

  resources :policy_coverage_status_histories

  resources :policy_program_histories

  resources :final_policy_group_rating_and_premium_projections

  resources :policy_calculations do
    collection {get 'create_policy_objects'}
  end

  resources :group_rating_exceptions do
    post :resolve
  end

  resources :representatives do
    get :users_management
    post :fee_calculations
    get :export_manual_classes
    get :export_policies
    get :export_accounts
    get :export_159_request_weekly
    post :import_contact_process
    post :import_payroll_process
    post :import_claim_process
    get :all_quote_process
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

  resources :versions

  resources :welcome

  root 'welcome#index'

end
