ActiveAdmin.register Quote do
  includes :account

  index do
    selectable_column
    id_column
    column :account_id do |i|
      i.account.name
    end
    column 'Policy Number',  :account_id do |i|
      i.account.policy_number_entered
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
end
