ActiveAdmin.register Account do
  includes :representative
  actions :all, except: [:update, :destroy, :edit]
# permit_params :list, :of, :attributes, :on, :model
#

  index do
    selectable_column
    id_column
    column :representative_id do |i|
      i.representative.abbreviated_name
    end
    column :name
    column :policy_number_entered
    column :industry_group
    column :group_rating_qualification
    column :group_rating_tier
    column :group_rating_group_number
    column :group_premium
    column :group_savings
    column :group_retro_qualification
    column :group_retro_tier
    column :group_retro_group_number
    column :group_retro_premium
    column :group_retro_savings
    column :group_dues
    column :fee_override
    column :fee_change
    column :group_fees
    column :total_costs
    actions
  end

  filter :name
  filter :representative_id, as: :select, collection: Representative.options_for_select
  filter :policy_number_entered
  filter :industry_group
  filter :group_rating_qualification
  filter :group_rating_tier
  filter :group_retro_qualification
  filter :group_retro_tier
  filter :group_fees
  filter :fee_override

end
