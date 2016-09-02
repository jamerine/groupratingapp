# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# BWC Support Tables
  BwcCodesBaseRatesExpLossRate.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/bwc_expected_loss.csv')
  BwcCodesCredibilityMaxLoss.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/bwc_credibility_max_loss.csv')
  BwcCodesIndustryGroupSavingsRatioCriterium.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/Industry+Group+Savings+Ratio+Criteria.csv')
  BwcCodesLimitedLossRatio.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/limited_loss_ratio.csv')
  BwcCodesNcciManualClass.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/NCCI+Manual+Classes.csv')
  BwcCodesPolicyEffectiveDate.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/BWC+History+with+Pol+and+Eff+Date.csv')
  BwcCodesPeoList.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/peo_list.csv')
  BwcCodesConstantValue.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/bwc_codes_constant_values.csv')

  representatives = Representative.create([{ representative_number: 219406, abbreviated_name: 'ARM' }, { representative_number: 217564, abbreviated_name: 'ECP' }, { representative_number: 218373, abbreviated_name: 'ERSCO' }, { representative_number: 1714, abbreviated_name: 'GCADA' }, { representative_number: 217381, abbreviated_name: 'GMS' }, { representative_number: 1796, abbreviated_name: 'MAAG' }, { representative_number: 1740, abbreviated_name: 'MATRIX' }, { representative_number: 20634, abbreviated_name: 'OBRIEN' }, { representative_number: 217395, abbreviated_name: 'RCOC' }, { representative_number: 219952, abbreviated_name: 'SCLLC' }, { representative_number: 218961, abbreviated_name: 'TRIDENT' }, { representative_number: 217351, abbreviated_name: 'UNITED' }, { representative_number: 21152, abbreviated_name: 'WHPCB' }, { representative_number: 1633, abbreviated_name: 'MM' }])
