ActiveAdmin.register AccountProgram do
  actions :all, except: [:update, :destroy, :edit, :create, :new]

  index do
    column :representative do |i|
      i.representative.abbreviated_name
    end
    column :account
    column 'Policy Number', :account do |i|
      i.account.policy_number_entered
    end
    column :program_type
    column :quote_tier
    column :group_code
    column :fees_amount
    column :paid_amount
    column :effective_start_date
    column :effective_end_date
    column :created_at

    actions
  end
  filter :representative, as: :select, collection: Representative.options_for_select
  filter :program_type, as: :select, collection: proc { AccountProgram.program_types.keys }
  filter :account_policy_number_entered_eq, label: 'Policy Number'
  filter :quoted_tier
  filter :group_code
  filter :fees_amount, as: :numeric
  filter :paid_amount, as: :numeric
  filter :effective_start_date, as: :date_range
  filter :effective_end_date, as: :date_range
  filter :created_at, as: :date_range

end
