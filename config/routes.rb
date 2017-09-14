require 'sidekiq/web'

Rails.application.routes.draw do

  mount Sidekiq::Web, at: '/sidekiq'


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
    get :new_risk_report
    get :roc_report

    resources :notes do
      delete :remove_attachment
    end
  end

  resources :account_programs do
    collection { post :import_account_program_process }
    collection { put :update_individual }
  end

  resources :affiliates do
    collection { post :import_affiliate_process }
  end

  resources :claim_calculations

  resources :contacts do
    collection { post :import_contact_process }
  end

  resources :democ_detail_records do
     collection { post :parse }
     collection { delete :destroy}
  end

  resources :fees do
    collection { get :edit_individual }
    collection { put :update_individual }
    collection { post :fee_accounts }
  end

  resources :final_policy_group_rating_and_premium_projections

  resources :group_ratings

  resources :group_rating_exceptions do
    post :resolve
  end

  resources :imports do
    collection { delete :destroy }
  end

  resources :manual_class_calculations do
    collection {get 'create_manual_class_objects'}
  end

  resources :mremp_employer_experience do
     collection { post :parse }
     collection { delete :destroy}
  end

  resources :mrcl_detail_records do
     collection { post :parse }
     collection { delete :destroy}
  end

  resources :parse do
    collection { delete :destroy}
  end

  resources :payroll_calculations

  resources :pcomb_detail_records do
     collection { post :parse }
     collection { delete :destroy}
  end


  resources :phmgn_detail_records do
     collection { post :parse }
     collection { delete :destroy}
  end

  resources :policy_calculations do
    collection {get 'create_policy_objects'}
  end

  resources :policy_coverage_status_histories

  resources :policy_program_histories

  resources :program_rejections do
    post :resolve
  end

  resources :quotes do
    get :group_rating_report
    collection { post :quote_accounts }
    collection { get :edit_quote_accounts }
    collection { post :generate_account_quotes }
    collection { delete :delete_all_quotes }
    get :view_group_rating_quote
    get :view_group_retro_quote
    get :view_invoice
    get :new_group_retro
    post :create_group_retro
  end

  resources :representatives do
    get :users_management
    post :fee_calculations
    get :export_manual_classes
    get :export_policies
    get :export_accounts
    post :export_159_request_weekly
    get :filter_export_159_request_weekly
    post :import_contact_process
    post :import_payroll_process
    post :import_claim_process
    get :all_quote_process
    post :zip_file
    get :edit_global_dates
  end

  resources :representatives_users

  resources :sc220_employer_demographics do
     collection { post :parse }
     collection { delete :destroy}
  end

  resources :sc230_employer_demographics do
     collection { post :parse }
     collection { delete :destroy}
  end

  devise_for :users, controllers: {
        sessions: 'users/sessions',
        confirmations: 'users/confirmations',
        registrations: 'users/registrations',
      }

  resources :users, except: :create

  post 'create_user' => 'users#create', as: :create_user

  resources :versions

  resources :welcome

  root 'welcome#index'

end
