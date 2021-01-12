ActiveAdmin.register Quote do
  actions :all, except: [:update, :destroy, :edit, :create, :new]

  index do
    column 'Representative', :representative do |i|
      i.account.representative.abbreviated_name
    end
    column :account_id do |i|
      i.account.name
    end
    column 'Policy Number',  :account_id do |i|
      i.account.policy_number_entered
    end
    column :status
    column :program_type
    column :group_code
    column :quote_tier
    column :fees
    column :program_year
    column :quote_year
    column :quote_date
    actions
  end

  # filter :representative, as: :select, collection: Representative.options_for_select
  filter :account_policy_number_entered_eq, label: 'Policy Number'
  # filter :program_type, as: :select, collection: proc { Quote.program_types.keys }
  filter :quote_tier, as: :numeric
  filter :fees, as: :numeric
  filter :quote_date, as: :date_range

end
