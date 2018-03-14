# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:


# BWC Support Tables
  # BwcCodesBaseRatesExpLossRate.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/bwc_expected_loss.csv')
  BwcCodesBaseRatesExpLossRate.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/bwc_expected_loss_2017.csv')
  BwcCodesCredibilityMaxLoss.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/bwc_credibility_max_loss.csv')
  BwcCodesIndustryGroupSavingsRatioCriterium.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/Industry+Group+Savings+Ratio+Criteria.csv')
  # BwcCodesLimitedLossRatio.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/limited_loss_ratio.csv')
  BwcCodesLimitedLossRatio.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/limited_loss_ratio_2017.csv')
  # BwcCodesNcciManualClass.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/NCCI+Manual+Classes.csv')
  BwcCodesNcciManualClass.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/NCCI+Manual+Classes_2017.csv')
  # BwcCodesPolicyEffectiveDate.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/BWC+History+with+Pol+and+Eff+Date.csv')
  BwcCodesPeoList.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/peo_list.csv')
  BwcCodesConstantValue.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/bwc_codes_constant_values.csv')
  BwcCodesEmployerRepresentative.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/Employer%2BRep%2BList.csv')
  # BwcGroupAcceptRejectList.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/2017+GROUP+ACCEPT_REJECT+LISTS+04-28-17.csv')
  BwcGroupAcceptRejectList.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/2018_group_accept_reject.csv')


  BwcCodesGroupRetroTier.create([
    { industry_group: 3, discount_tier: -0.51 },
    { industry_group: 7, discount_tier: -0.51 },
    { industry_group: 4, discount_tier: -0.49 },
    { industry_group: 8, discount_tier: -0.49 },
    { industry_group: 5, discount_tier: -0.43 }
    ])

  representatives = Representative.create([
    { representative_number: 219406, abbreviated_name: 'ARM', company_name: 'Alternative Risk Management', experience_period_lower_date: '2012-07-01', experience_period_upper_date: '2016-06-30', current_payroll_period_lower_date: '2015-07-01', current_payroll_period_upper_date: '2016-06-30', current_payroll_year: 2015, program_year_lower_date: '2017-07-01', program_year_upper_date: '2018-06-30', program_year: 2017, quote_year_lower_date: '2018-07-01', quote_year_upper_date: '2019-06-30', quote_year: 2018 },
    { representative_number: 217564, abbreviated_name: 'ECP', company_name: 'Employers Choice Plus', experience_period_lower_date: '2012-07-01', experience_period_upper_date: '2016-06-30', current_payroll_period_lower_date: '2015-07-01', current_payroll_period_upper_date: '2016-06-30', current_payroll_year: 2015, program_year_lower_date: '2017-07-01', program_year_upper_date: '2018-06-30', program_year: 2017, quote_year_lower_date: '2018-07-01', quote_year_upper_date: '2019-06-30', quote_year: 2018 },
    { representative_number: 1714, abbreviated_name: 'GCADA', company_name: 'Greater Cleveland Automobile Dealers', experience_period_lower_date: '2012-07-01', experience_period_upper_date: '2016-06-30', current_payroll_period_lower_date: '2015-07-01', current_payroll_period_upper_date: '2016-06-30', current_payroll_year: 2015, program_year_lower_date: '2017-07-01', program_year_upper_date: '2018-06-30', program_year: 2017, quote_year_lower_date: '2018-07-01', quote_year_upper_date: '2019-06-30', quote_year: 2018 },
    { representative_number: 1706, abbreviated_name: 'GMSCLI', company_name: 'Group Management Services Clients', experience_period_lower_date: '2012-07-01', experience_period_upper_date: '2016-06-30', current_payroll_period_lower_date: '2015-07-01', current_payroll_period_upper_date: '2016-06-30', current_payroll_year: 2015, program_year_lower_date: '2017-07-01', program_year_upper_date: '2018-06-30', program_year: 2017, quote_year_lower_date: '2018-07-01', quote_year_upper_date: '2019-06-30', quote_year: 2018 },
    { representative_number: 217381, abbreviated_name: 'GMSPRO', company_name: 'Group Management Services Prospects', experience_period_lower_date: '2012-07-01', experience_period_upper_date: '2016-06-30', current_payroll_period_lower_date: '2015-07-01', current_payroll_period_upper_date: '2016-06-30', current_payroll_year: 2015, program_year_lower_date: '2017-07-01', program_year_upper_date: '2018-06-30', program_year: 2017, quote_year_lower_date: '2018-07-01', quote_year_upper_date: '2019-06-30', quote_year: 2018 },
    { representative_number: 1796, abbreviated_name: 'MAAG' , company_name: 'Maag', experience_period_lower_date: '2012-07-01', experience_period_upper_date: '2016-06-30', current_payroll_period_lower_date: '2015-07-01', current_payroll_period_upper_date: '2016-06-30', current_payroll_year: 2015, program_year_lower_date: '2017-07-01', program_year_upper_date: '2018-06-30', program_year: 2017, quote_year_lower_date: '2018-07-01', quote_year_upper_date: '2019-06-30', quote_year: 2018},
    { representative_number: 1740, abbreviated_name: 'MATRIX', company_name: 'Matrix', experience_period_lower_date: '2012-07-01', experience_period_upper_date: '2016-06-30', current_payroll_period_lower_date: '2015-07-01', current_payroll_period_upper_date: '2016-06-30', current_payroll_year: 2015, program_year_lower_date: '2017-07-01', program_year_upper_date: '2018-06-30', program_year: 2017, quote_year_lower_date: '2018-07-01', quote_year_upper_date: '2019-06-30', quote_year: 2018 },
    { representative_number: 20634, abbreviated_name: 'OBRIEN', company_name: "Dan O'Brien", experience_period_lower_date: '2012-07-01', experience_period_upper_date: '2016-06-30', current_payroll_period_lower_date: '2015-07-01', current_payroll_period_upper_date: '2016-06-30', current_payroll_year: 2015, program_year_lower_date: '2017-07-01', program_year_upper_date: '2018-06-30', program_year: 2017, quote_year_lower_date: '2018-07-01', quote_year_upper_date: '2019-06-30', quote_year: 2018 },
    { representative_number: 219952, abbreviated_name: 'SCLLC', company_name: 'Tom Stefanik', experience_period_lower_date: '2012-07-01', experience_period_upper_date: '2016-06-30', current_payroll_period_lower_date: '2015-07-01', current_payroll_period_upper_date: '2016-06-30', current_payroll_year: 2015, program_year_lower_date: '2017-07-01', program_year_upper_date: '2018-06-30', program_year: 2017, quote_year_lower_date: '2018-07-01', quote_year_upper_date: '2019-06-30', quote_year: 2018  },
    { representative_number: 218961, abbreviated_name: 'TRIDENT', company_name: 'Trident', experience_period_lower_date: '2012-07-01', experience_period_upper_date: '2016-06-30', current_payroll_period_lower_date: '2015-07-01', current_payroll_period_upper_date: '2016-06-30', current_payroll_year: 2015, program_year_lower_date: '2017-07-01', program_year_upper_date: '2018-06-30', program_year: 2017, quote_year_lower_date: '2018-07-01', quote_year_upper_date: '2019-06-30', quote_year: 2018 },
    { representative_number: 217351, abbreviated_name: 'UNITED', company_name: 'United Corp', experience_period_lower_date: '2012-07-01', experience_period_upper_date: '2016-06-30', current_payroll_period_lower_date: '2015-07-01', current_payroll_period_upper_date: '2016-06-30', current_payroll_year: 2015, program_year_lower_date: '2017-07-01', program_year_upper_date: '2018-06-30', program_year: 2017, quote_year_lower_date: '2018-07-01', quote_year_upper_date: '2019-06-30', quote_year: 2018 },
    { representative_number: 21152, abbreviated_name: 'WHPCB', company_name: 'Wickens Herzer', experience_period_lower_date: '2012-07-01', experience_period_upper_date: '2016-06-30', current_payroll_period_lower_date: '2015-07-01', current_payroll_period_upper_date: '2016-06-30', current_payroll_year: 2015, program_year_lower_date: '2017-07-01', program_year_upper_date: '2018-06-30', program_year: 2017, quote_year_lower_date: '2018-07-01', quote_year_upper_date: '2019-06-30', quote_year: 2018  },
    { representative_number: 222188, abbreviated_name: 'CES', company_name: 'CES', experience_period_lower_date: '2012-07-01', experience_period_upper_date: '2016-06-30', current_payroll_period_lower_date: '2015-07-01', current_payroll_period_upper_date: '2016-06-30', current_payroll_year: 2015, program_year_lower_date: '2017-07-01', program_year_upper_date: '2018-06-30', program_year: 2017, quote_year_lower_date: '2018-07-01', quote_year_upper_date: '2019-06-30', quote_year: 2018  }
    ])
AdminUser.create!(email: 'dmaag@alternativeriskltd.com', password: 'tigers', password_confirmation: 'tigers')
AdminUser.create!(email: 'tbetz@alternativeriskltd.com', password: 'password', password_confirmation: 'password')
User.create({first_name: "Jason", last_name: "Amerine", role: 0, email: 'jason@dittoh.com', password: 'Jamrine08'})
# User.create({first_name: "Paul", last_name: "Collins", role: 0, email: 'paul@dittoh.com', password: 'password'})
# User.create({first_name: "Doug", last_name: "Maag", role: 0, email: 'dmaag@alternativeriskltd.com', password: 'tigers'})
# User.create({first_name: "Tim", last_name: "Betz", role: 0, email: 'tbetz@alternativeriskltd.com', password: 'password'})
# User.create({first_name: "Richard", last_name: "Kurth", role: 0, email: 'rkurth@alternativeriskltd.com', password: 'password'})
# User.create({first_name: "Deanna", last_name: "Sanders", role: 2, email: 'dsanders@alternativeriskltd.com', password: 'password'})
# User.create({first_name: "Paul", last_name: "Kay", role: 2, email: 'PaulKay@alternativeriskltd.com', password: 'password'})
# User.create({first_name: "Stephanie", last_name: "Shepherd", role: 2, email: 'sshepherd@alternativeriskltd.com', password: 'password'})
# User.create({first_name: "Jessica", last_name: "Abrams", role: 2, email: 'jabrams@alternativeriskltd.com', password: 'password'})



RepresentativesUser.create({user_id: 1, representative_id: 1})
RepresentativesUser.create({user_id: 1, representative_id: 2})
RepresentativesUser.create({user_id: 1, representative_id: 3})
RepresentativesUser.create({user_id: 1, representative_id: 4})
RepresentativesUser.create({user_id: 1, representative_id: 5})
RepresentativesUser.create({user_id: 1, representative_id: 6})
RepresentativesUser.create({user_id: 1, representative_id: 7})
RepresentativesUser.create({user_id: 1, representative_id: 8})
RepresentativesUser.create({user_id: 1, representative_id: 9})
RepresentativesUser.create({user_id: 1, representative_id: 10})
RepresentativesUser.create({user_id: 1, representative_id: 11})
RepresentativesUser.create({user_id: 1, representative_id: 12})
RepresentativesUser.create({user_id: 1, representative_id: 13})
# RepresentativesUser.create({user_id: 2, representative_id: 1})
# RepresentativesUser.create({user_id: 2, representative_id: 18})
# RepresentativesUser.create({user_id: 3, representative_id: 1})
# RepresentativesUser.create({user_id: 3, representative_id: 3})
# RepresentativesUser.create({user_id: 3, representative_id: 4})
# RepresentativesUser.create({user_id: 3, representative_id: 5})
# RepresentativesUser.create({user_id: 3, representative_id: 6})
# RepresentativesUser.create({user_id: 3, representative_id: 7})
# RepresentativesUser.create({user_id: 3, representative_id: 8})
# RepresentativesUser.create({user_id: 3, representative_id: 11})
# RepresentativesUser.create({user_id: 3, representative_id: 12})
# RepresentativesUser.create({user_id: 3, representative_id: 13})
# RepresentativesUser.create({user_id: 3, representative_id: 14})
# RepresentativesUser.create({user_id: 3, representative_id: 15})
# RepresentativesUser.create({user_id: 3, representative_id: 18})
# RepresentativesUser.create({user_id: 5, representative_id: 1})
# RepresentativesUser.create({user_id: 5, representative_id: 3})
# RepresentativesUser.create({user_id: 5, representative_id: 4})
# RepresentativesUser.create({user_id: 5, representative_id: 5})
# RepresentativesUser.create({user_id: 5, representative_id: 6})
# RepresentativesUser.create({user_id: 5, representative_id: 7})
# RepresentativesUser.create({user_id: 5, representative_id: 8})
# RepresentativesUser.create({user_id: 5, representative_id: 11})
# RepresentativesUser.create({user_id: 5, representative_id: 12})
# RepresentativesUser.create({user_id: 5, representative_id: 13})
# RepresentativesUser.create({user_id: 5, representative_id: 14})
# RepresentativesUser.create({user_id: 5, representative_id: 15})
# RepresentativesUser.create({user_id: 5, representative_id: 18})
# RepresentativesUser.create({user_id: 6, representative_id: 1})
# RepresentativesUser.create({user_id: 6, representative_id: 18})
# RepresentativesUser.create({user_id: 7, representative_id: 1})
# RepresentativesUser.create({user_id: 8, representative_id: 1})
# RepresentativesUser.create({user_id: 17, representative_id: 1})
# RepresentativesUser.create({user_id: 18, representative_id: 1})
# RepresentativesUser.create({user_id: 1, representative_id: 18})


BwcAnnualManualClassChange.create([
  { manual_class_from: 8061, manual_class_to: 8006, policy_year: 1999 },
  { manual_class_from: 9549, manual_class_to: 9554, policy_year: 2000 },
  { manual_class_from: 9552, manual_class_to: 9554, policy_year: 2000 },
  { manual_class_from: 9545, manual_class_to: 9554, policy_year: 2001 },
  { manual_class_from: 2150, manual_class_to: 8203, policy_year: 2005 },
  { manual_class_from: 2576, manual_class_to: 2501, policy_year: 2005 },
  { manual_class_from: 5536, manual_class_to: 5537, policy_year: 2005 },
  { manual_class_from: 7423, manual_class_to: 7403, policy_year: 2005 },
  { manual_class_from: 3066, manual_class_to: 3076, policy_year: 2006 },
  { manual_class_from: 2156, manual_class_to: 2157, policy_year: 2007 },
  { manual_class_from: 8861, manual_class_to: 8864, policy_year: 2007 },
  { manual_class_from: 9110, manual_class_to: 8864, policy_year: 2007 },
  { manual_class_from: 2812, manual_class_to: 2883, policy_year: 2010 },
  { manual_class_from: 5651, manual_class_to: 5645, policy_year: 2010 },
  { manual_class_from: 7611, manual_class_to: 7600, policy_year: 2010 },
  { manual_class_from: 7612, manual_class_to: 7600, policy_year: 2010 },
  { manual_class_from: 9059, manual_class_to: 8869, policy_year: 2010 },
  { manual_class_from: 5538, manual_class_to: 5537, policy_year: 2011 },
  { manual_class_from: 3069, manual_class_to: 3076, policy_year: 2014 },
  { manual_class_from: 1655, manual_class_to: 1642, policy_year: 2016 },
  { manual_class_from: 1741, manual_class_to: 1701, policy_year: 2016 },
  { manual_class_from: 1853, manual_class_to: 1701, policy_year: 2016 },
  { manual_class_from: 1860, manual_class_to: 4279, policy_year: 2016 },
  { manual_class_from: 2534, manual_class_to: 2501, policy_year: 2016 },
  { manual_class_from: 3175, manual_class_to: 3169, policy_year: 2016 },
  { manual_class_from: 3223, manual_class_to: 3180, policy_year: 2016 },
  { manual_class_from: 4053, manual_class_to: 4062, policy_year: 2016 },
  { manual_class_from: 4061, manual_class_to: 4062, policy_year: 2016 },
  { manual_class_from: 4113, manual_class_to: 4111, policy_year: 2016 },
  { manual_class_from: 4282, manual_class_to: 4279, policy_year: 2016 },
  { manual_class_from: 4439, manual_class_to: 4558, policy_year: 2016 },
  { manual_class_from: 5069, manual_class_to: 5059, policy_year: 2016 },
  { manual_class_from: 6017, manual_class_to: 5213, policy_year: 2016 },
  { manual_class_from: 7228, manual_class_to: 7219, policy_year: 2016 },
  { manual_class_from: 7229, manual_class_to: 7219, policy_year: 2016 }
])



##### MMHR CONVERSIONS 06-19 #####
# AccountImportProcess.perform_async('https://s3.amazonaws.com/grouprating/Conversions/MMHR/all_account_update_customer_table_6_8.csv')
# ContactImportProcess.perform_async('https://s3.amazonaws.com/grouprating/Conversions/MMHR/contact_6_12.csv')
# AffiliateImportProcess.perform_async('https://s3.amazonaws.com/grouprating/Conversions/MMHR/Allifiates_6_12.csv')
# AccountProgramImportProcess.perform_async('https://s3.amazonaws.com/grouprating/Conversions/MMHR/current_customer_table_6_9.csv')
# QuoteImportProcess.perform_async('https://s3.amazonaws.com/grouprating/Conversions/MMHR/quotes_6_16.csv')


##### ARM CONVERSION 06-19 #####
# AccountImportProcess.perform_async('https://s3.amazonaws.com/grouprating/Conversions/ARM/ARM+Account+Update+Import.csv')
# AccountProgramImportProcess.perform_async('https://s3.amazonaws.com/grouprating/Conversions/ARM/ARM_2017_Account_Programs_05_02.csv')

# @representative = Representative.find(16)
#
# @representative.policy_calculations.limit(500).destroy_all
# @representative.accounts.limit(1000).destroy_all
# @representative.destroy
#
# @representative = Representative.find(17)
# @representative.policy_calculations.limit(1000).destroy_all
# @representative.accounts.limit(1000).destroy_all
# @representative.destroy
#
# @representative = Representative.find(2)
# @representative.policy_calculations.limit(1000).destroy_all
# @representative.accounts.limit(1000).destroy_all
# @representative.destroy
#
# @representative = Representative.find(9)
# @representative.policy_calculations.limit(1000).destroy_all
# @representative.accounts.limit(1000).destroy_all
# @representative.destroy
#
# @representative = Representative.find(10)
# @representative.policy_calculations.limit(1000).destroy_all
# @representative.accounts.limit(1000).destroy_all
# @representative.destroy
AdminUser.create!(email: 'jason@dittoh.com', password: 'Jamrine08', password_confirmation: 'Jamrine08') if Rails.env.development?

ContactType.create([{name: "billing"}, {name: "claims"}, {name: "hr"}, {name: "owner"}, {name: "tpa"}])