namespace :group_retro_tiers do
  desc 'Update Group Retro Tiers With Data for IG 12 and 15 per client request - 2/26/21'
  task update_industry_groups: :environment do
    BwcCodesGroupRetroTier.find_or_create_by(industry_group: 12, discount_tier: -0.38, public_employer_only: true)
    BwcCodesGroupRetroTier.find_or_create_by(industry_group: 15, discount_tier: -0.38, public_employer_only: true)
  end
end