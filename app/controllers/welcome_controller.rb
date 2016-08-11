class WelcomeController < ApplicationController
  def index

  end

  def import
    # time1 = Time.new
    # puts "Process Start Time: " + time1.inspect
    #   # Flat files
    #   Democ.import_file("https://s3.amazonaws.com/grouprating/ARM/DEMOCFILE")
    #   Mrcl.import_file("https://s3.amazonaws.com/grouprating/ARM/MRCLSFILE")
    #   Mremp.import_file("https://s3.amazonaws.com/grouprating/ARM/MREMPFILE")
    #   Pcomb.import_file("https://s3.amazonaws.com/grouprating/ARM/PCOMBFILE")
    #   Phmgn.import_file("https://s3.amazonaws.com/grouprating/ARM/PHMGNFILE")
    #   Sc220.import_file("https://s3.amazonaws.com/grouprating/ARM/SC220FILE")
    #   Sc230.import_file("https://s3.amazonaws.com/grouprating/ARM/SC230FILE")
    #
    #   # BWC Support Tables
    #   BwcCodesBaseRatesExpLossRate.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/bwc_expected_loss.csv')
    #   BwcCodesCredibilityMaxLoss.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/bwc_credibility_max_loss.csv')
    #   BwcCodesIndustryGroupSavingsRatioCriterium.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/Industry+Group+Savings+Ratio+Criteria.csv')
    #   BwcCodesLimitedLossRatio.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/limited_loss_ratio.csv')
    #   BwcCodesNcciManualClass.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/NCCI+Manual+Classes.csv')
    #   BwcCodesPolicyEffectiveDate.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/BWC+History+with+Pol+and+Eff+Date.csv')
    #   BwcCodesPeoList.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/peo_list.csv')
    #   BwcCodesConstantValue.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/bwc_codes_constant_values.csv')
    #
    # redirect_to root_url, notice: "The Democ, Mrcl, Mremp, Pcomb, Phmgn, SC220, and SC230 files have been imported"
    # time2 = Time.new
    # puts "Process End Time: " + time2.inspect
  end

  def parse
    
  end

  def destroy

  end


end
