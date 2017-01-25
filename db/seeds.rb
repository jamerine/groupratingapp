# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:


# BWC Support Tables
  BwcCodesBaseRatesExpLossRate.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/bwc_expected_loss.csv')
  BwcCodesCredibilityMaxLoss.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/bwc_credibility_max_loss.csv')
  BwcCodesIndustryGroupSavingsRatioCriterium.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/Industry+Group+Savings+Ratio+Criteria.csv')
  BwcCodesLimitedLossRatio.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/limited_loss_ratio.csv')
  BwcCodesNcciManualClass.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/NCCI+Manual+Classes.csv')
  # BwcCodesPolicyEffectiveDate.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/BWC+History+with+Pol+and+Eff+Date.csv')
  BwcCodesPeoList.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/peo_list.csv')
  BwcCodesConstantValue.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/bwc_codes_constant_values.csv')

  BwcCodesGroupRetroTier.create([
    { industry_group: 3, discount_tier: -0.51 },
    { industry_group: 7, discount_tier: -0.51 },
    { industry_group: 4, discount_tier: -0.49 },
    { industry_group: 8, discount_tier: -0.49 },
    { industry_group: 5, discount_tier: -0.43 },
    ])

  representatives = Representative.create([
    { representative_number: 219406, abbreviated_name: 'ARM', company_name: 'Alternative Risk Management' },
    { representative_number: 218265, abbreviated_name: 'COSE', company_name: 'Council of Smaller Enterprises' },
    { representative_number: 217564, abbreviated_name: 'ECP', company_name: 'Employers Choice Plus' },
    { representative_number: 218373, abbreviated_name: 'ERSCO', company_name: 'Employer Risk Solutions Company' },
    { representative_number: 1714, abbreviated_name: 'GCADA', company_name: 'Greater Cleveland Automobile Dealers' },
    { representative_number: 1706, abbreviated_name: 'GMSCLI', company_name: 'Group Management Services Clients' },
    { representative_number: 217381, abbreviated_name: 'GMSPRO', company_name: 'Group Management Services Prospects' },
    { representative_number: 1796, abbreviated_name: 'MAAG' , company_name: 'Maag'},
    { representative_number: 1740, abbreviated_name: 'MATRIX', company_name: 'Matrix' },
    { representative_number: 220217, abbreviated_name: 'MMHR2', company_name: 'Minute Man HR' },
    { representative_number: 219313, abbreviated_name: 'MMHR1', company_name: 'Minute Men Select' },
    { representative_number: 20634, abbreviated_name: 'OBRIEN', company_name: "Dan O'Brien" },
    { representative_number: 217395, abbreviated_name: 'RCOC', company_name: 'Robinson Curphey'  },
    { representative_number: 219952, abbreviated_name: 'SCLLC', company_name: 'Tom Stefanik'  },
    { representative_number: 218961, abbreviated_name: 'TRIDENT', company_name: 'Trident' },
    { representative_number: 217351, abbreviated_name: 'UNITED', company_name: 'United Corp' },
    { representative_number: 21152, abbreviated_name: 'WHPCB', company_name: 'Wickens Herzer'  },
    { representative_number: 1633, abbreviated_name: 'CPM', company_name: 'CPM Risk Management'  }

    ])

User.create({first_name: "Jason", last_name: "Amerine", email: 'jason@dittoh.com', password: 'Jamrine08'})
User.create({first_name: "Paul", last_name: "Collins", email: 'paul@dittoh.com', password: 'password'})
User.create({first_name: "Cory", last_name: "Miller", email: 'millercj320@gmail.com', password: 'password'})
User.create({first_name: "Doug", last_name: "Maag", email: 'dmaag@alternativeriskltd.com', password: 'tigers'})
User.create({first_name: "Steve", last_name: "Chmielewski", email: 'steve.chmielewski@minutemenhr.com', password: 'indians'})
User.create({first_name: "Tim", last_name: "Betz", email: 'tbetz@alternativeriskltd.com', password: 'password'})



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
RepresentativesUser.create({user_id: 1, representative_id: 14})
RepresentativesUser.create({user_id: 1, representative_id: 15})
RepresentativesUser.create({user_id: 1, representative_id: 16})
RepresentativesUser.create({user_id: 1, representative_id: 17})
RepresentativesUser.create({user_id: 1, representative_id: 18})
RepresentativesUser.create({user_id: 2, representative_id: 1})
RepresentativesUser.create({user_id: 2, representative_id: 17})
RepresentativesUser.create({user_id: 4, representative_id: 1})
RepresentativesUser.create({user_id: 4, representative_id: 3})
RepresentativesUser.create({user_id: 4, representative_id: 4})
RepresentativesUser.create({user_id: 4, representative_id: 5})
RepresentativesUser.create({user_id: 4, representative_id: 6})
RepresentativesUser.create({user_id: 4, representative_id: 7})
RepresentativesUser.create({user_id: 4, representative_id: 8})
RepresentativesUser.create({user_id: 4, representative_id: 9})
RepresentativesUser.create({user_id: 4, representative_id: 12})
RepresentativesUser.create({user_id: 4, representative_id: 13})
RepresentativesUser.create({user_id: 4, representative_id: 14})
RepresentativesUser.create({user_id: 4, representative_id: 15})
RepresentativesUser.create({user_id: 4, representative_id: 16})
RepresentativesUser.create({user_id: 4, representative_id: 17})
RepresentativesUser.create({user_id: 5, representative_id: 2})
RepresentativesUser.create({user_id: 5, representative_id: 10})
RepresentativesUser.create({user_id: 5, representative_id: 11})
RepresentativesUser.create({user_id: 5, representative_id: 18})
RepresentativesUser.create({user_id: 6, representative_id: 1})
RepresentativesUser.create({user_id: 6, representative_id: 3})
RepresentativesUser.create({user_id: 6, representative_id: 4})
RepresentativesUser.create({user_id: 6, representative_id: 5})
RepresentativesUser.create({user_id: 6, representative_id: 6})
RepresentativesUser.create({user_id: 6, representative_id: 7})
RepresentativesUser.create({user_id: 6, representative_id: 8})
RepresentativesUser.create({user_id: 6, representative_id: 9})
RepresentativesUser.create({user_id: 6, representative_id: 12})
RepresentativesUser.create({user_id: 6, representative_id: 13})
RepresentativesUser.create({user_id: 6, representative_id: 14})
RepresentativesUser.create({user_id: 6, representative_id: 15})
RepresentativesUser.create({user_id: 6, representative_id: 16})
RepresentativesUser.create({user_id: 6, representative_id: 17})
