ActiveAdmin.register ManualClassCalculation do
  actions :all, except: [:update, :destroy, :edit, :create, :new]
  config.per_page = [25, 50, 100]

  index do
    selectable_column
    column :representative do |i|
      i.representative.abbreviated_name
    end
    column :policy_number
    column :manual_class_type
    column :manual_number
    column '4yr Payroll', :manual_class_four_year_period_payroll
    column 'Exp Loss Rate', :manual_class_expected_loss_rate
    column 'Base Rate', :manual_class_base_rate
    column 'Exp Losses', :manual_class_expected_losses
    column 'IG', :manual_class_industry_group
    column 'LLR', :manual_class_limited_loss_rate
    column 'Limited Losses', :manual_class_limited_losses
    column 'Current Exp Payroll', :manual_class_current_estimated_payroll
    column 'Mod Rate', :manual_class_modification_rate
    column 'Ind Total Rate', :manual_class_individual_total_rate
    column 'Group Total Rate', :manual_class_group_total_rate
    column 'Stnd Prem', :manual_class_standard_premium
    column 'Est Group Prem', :manual_class_estimated_group_premium
    column 'Est Ind Prem', :manual_class_estimated_individual_premium
    column 'IG Prem %', :manual_class_industry_group_premium_percentage


    actions
  end

  filter :representative, as: :select, collection: Representative.options_for_select
  filter :policy_number, as: :numeric
  filter :manual_number, as: :numeric
  filter :manual_class_industry_group, as: :numeric
  filter :manual_class_type
end
