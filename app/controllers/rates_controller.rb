class RatesController < ApplicationController
  def index
    @base_rates    = BwcCodesBaseRatesExpLossRate.all.includes(:bwc_codes_ncci_manual_class)
    @limited_rates = BwcCodesLimitedLossRatio.all
  end


end