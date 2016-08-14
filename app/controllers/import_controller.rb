class ImportController < ApplicationController
  def show

  end

  def index
    @democs = Democ.all
    @mrcls = Mrcl.all
    @mremps = Mremp.all
    @pcombs = Pcomb.all
    @phmgns = Phmgn.all
    @sc220s = Sc220.all
    @sc230s = Sc230.all
    @democ_count = Democ.count
    @mrcl_count = Mrcl.count
    @mremp_count = Mremp.count
    @pcomb_count = Pcomb.count
    @phmgn_count = Phmgn.count
    @sc220_count = Sc220.count
    @sc230_count = Sc230.count
  end
  def edit
  end

  def update
  end

  def destroy
    Democ.delete_all
    Mrcl.delete_all
    Mremp.delete_all
    Pcomb.delete_all
    Phmgn.delete_all
    Sc220.delete_all
    Sc230.delete_all

    BwcCodesBaseRatesExpLossRate.delete_all
    BwcCodesCredibilityMaxLoss.delete_all
    BwcCodesIndustryGroupSavingsRatioCriterium.delete_all
    BwcCodesLimitedLossRatio.delete_all
    BwcCodesNcciManualClass.delete_all
    BwcCodesPolicyEffectiveDate.delete_all
    BwcCodesPeoList.delete_all
    BwcCodesConstantValue.delete_all

    redirect_to import_index_path, notice: "All files are deleted."
  end

  def new
  end

  def create
    time1 = Time.new
    puts "Process Start Time: " + time1.inspect
      # Flat files
      Democ.import_file("https://s3.amazonaws.com/grouprating/ARM/DEMOCFILE")
      Mrcl.import_file("https://s3.amazonaws.com/grouprating/ARM/MRCLSFILE")
      Mremp.import_file("https://s3.amazonaws.com/grouprating/ARM/MREMPFILE")
      Pcomb.import_file("https://s3.amazonaws.com/grouprating/ARM/PCOMBFILE")
      Phmgn.import_file("https://s3.amazonaws.com/grouprating/ARM/PHMGNFILE")
      Sc220.import_file("https://s3.amazonaws.com/grouprating/ARM/SC220FILE")
      Sc230.import_file("https://s3.amazonaws.com/grouprating/ARM/SC230FILE")

      # BWC Support Tables
      BwcCodesBaseRatesExpLossRate.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/bwc_expected_loss.csv')
      BwcCodesCredibilityMaxLoss.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/bwc_credibility_max_loss.csv')
      BwcCodesIndustryGroupSavingsRatioCriterium.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/Industry+Group+Savings+Ratio+Criteria.csv')
      BwcCodesLimitedLossRatio.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/limited_loss_ratio.csv')
      BwcCodesNcciManualClass.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/NCCI+Manual+Classes.csv')
      BwcCodesPolicyEffectiveDate.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/BWC+History+with+Pol+and+Eff+Date.csv')
      BwcCodesPeoList.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/peo_list.csv')
      BwcCodesConstantValue.import_table('https://s3.amazonaws.com/grouprating/BwcSupportTables/bwc_codes_constant_values.csv')

      redirect_to import_index_path, notice: "All files are uploaded."
    time2 = Time.new
    puts "Process End Time: " + time2.inspect

  end
end
