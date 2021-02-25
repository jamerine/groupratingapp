class RatesController < ApplicationController
  require 'csv'
  require 'open-uri'

  before_action :authorize_admin
  before_action :handle_retro_tiers, :handle_rates_updates, :handle_administrative_rate, only: :create

  def index
    if params[:year].present?
      @year          = params[:year].to_i
      @base_rates    = BwcCodesBaseRatesHistoricalDatum.by_year(@year)
      @limited_rates = BwcCodesLimitedLossRatesHistoricalDatum.by_year(@year)
    else
      @base_rates    = BwcCodesBaseRatesExpLossRate.all.includes(:bwc_codes_ncci_manual_class)
      @limited_rates = BwcCodesLimitedLossRatio.all
    end

    @administrative_rate = BwcCodesConstantValue.current_rate
    @retro_tiers         = BwcCodesGroupRetroTier.all
    @historical_years    = [BwcCodesBaseRatesHistoricalDatum::AVAILABLE_YEARS, BwcCodesLimitedLossRatesHistoricalDatum::AVAILABLE_YEARS].flatten.uniq
  end

  def create
    if @base_rates.any? || @limited_loss_rates.any?
      render :edit
    else
      redirect_to action: :index
    end
  end

  private

  def rates_params
    params.require(:rates).permit(:base_rates_file, :limited_loss_rates_file, :administrative_rate, :administrative_rate_start_date, retro_tiers: [:industry_group, :discount_tier], max_values: [:id, :maximum_value])
  end

  def handle_retro_tiers
    if rates_params[:retro_tiers].present? && rates_params[:retro_tiers].any?
      rates_params[:retro_tiers].each do |tier|
        return unless tier[:discount_tier].present?
        if BwcCodesGroupRetroTier.find_by_industry_group(tier[:industry_group].to_i).update_attributes(discount_tier: tier[:discount_tier].to_f)
          flash[:notice] = 'Successfully Updated the Discount Rates!'
        else
          flash[:error] = 'Something went wrong updating the Discount Rates!'
        end
      end
    end
  end

  def handle_administrative_rate
    if rates_params[:administrative_rate].present?
      unless rates_params[:administrative_rate_start_date].present?
        flash[:error] = 'Administrative Rate Start Date is required if a rate is set!'
        redirect_to action: :index and return
      end

      BwcCodesConstantValue.all.each { |rate| rate.update_attribute(:completed_date, Date.today) if rate.completed_date.nil? }

      if BwcCodesConstantValue.find_or_create_by(name: :administrative_rate, rate: rates_params[:administrative_rate].try(:to_f), start_date: DateTime.strptime(rates_params[:administrative_rate_start_date], '%m/%d/%Y'), completed_date: nil)
        flash[:notice] = 'Successfully Updated Rates!'
      end
    end
  end

  def handle_rates_updates
    base_rates_file    = rates_params[:base_rates_file]
    limited_rates_file = rates_params[:limited_loss_rates_file]

    @base_rates         = []
    @limited_loss_rates = []

    if base_rates_file.present?
      unless base_rates_file.content_type == 'text/csv'
        flash[:error] = 'Base Rates File must be a CSV file!'
        redirect_to action: :index and return
      end

      @base_rates = parse_csv(base_rates_file)

      if @base_rates.nil?
        flash[:error] = 'Something went wrong on import!'
      else
        handle_old_base_data_transfer
        update_class_codes(@base_rates)
        update_base_rates(@base_rates)

        flash[:notice] = 'Successfully Imported File!'
      end
    end

    if limited_rates_file.present?
      unless limited_rates_file.content_type == 'text/csv'
        flash[:error] = 'Limited Loss Rates File must be a CSV file!'
        redirect_to action: :index and return
      end

      @limited_loss_rates = parse_limited_csv(limited_rates_file)

      if @limited_loss_rates.nil?
        flash[:error] = 'Something went wrong on import!'
      else
        handle_old_limited_loss_data_transfer
        update_limited_rates(@limited_loss_rates)

        flash[:notice] = 'Successfully Imported File!'
      end
    end
  end

  def handle_old_base_data_transfer
    BwcCodesBaseRatesExpLossRate.all.includes(:bwc_codes_ncci_manual_class).each { |rate| BwcCodesBaseRatesHistoricalDatum.find_or_create_by(year: Time.now.year - 1, class_code: rate.class_code, industry_group: rate.industry_group, base_rate: rate.base_rate, expected_loss_rate: rate.expected_loss_rate) }
  end

  def handle_old_limited_loss_data_transfer
    BwcCodesLimitedLossRatio.all.each { |rate| BwcCodesLimitedLossRatesHistoricalDatum.find_or_create_by(year: Time.now.year - 1, industry_group: rate.industry_group, credibility_group: rate.credibility_group, limited_loss_ratio: rate.limited_loss_ratio) }
  end

  def parse_csv(csv_file)
    begin
      rows      = CSV.read(csv_file.path)
      file_data = []

      rows.each_with_index do |row, index|
        file_data << row if index > 1
      end

      create_import_hash(file_data)
    rescue
      flash[:error] = 'There was an error importing the file.'
    end
  end

  def parse_limited_csv(csv_file)
    begin
      rows      = CSV.read(csv_file.path)
      file_data = []

      rows.each { |row| file_data << row }

      flash[:success] = 'Successfully Imported File!'
      create_limited_hash(file_data)
    rescue
      flash[:error] = 'There was an error importing the file.'
    end
  end

  def create_import_hash(file_data)
    file_data.map do |column|
      {
        industry_group:               column[0],
        class_code:                   column[1],
        base_rate:                    column[2],
        base_rate_old:                column[3],
        percent_change_base_rate:     column[4],
        expected_loss_rate:           column[6],
        expected_loss_rate_old:       column[7],
        percent_change_expected_rate: column[8]
      }
    end
  end

  def create_limited_hash(file_data)
    data = []

    file_data.each_with_index do |columns, row_index|
      if row_index > 0
        credibility_number = columns[0]

        [*1..22].each do |index|
          data << {
            credibility_number: credibility_number.to_i,
            industry_group:     index,
            loss_ratio:         columns[index],
            old_loss_ratio:     BwcCodesLimitedLossRatio.find_by(credibility_group: credibility_number, industry_group: index)&.limited_loss_ratio
          }
        end
      end
    end

    data
  end

  def update_class_codes(base_rate_hash)
    base_rate_hash.each do |hash|
      BwcCodesNcciManualClass.find_or_create_by(industry_group: hash[:industry_group], ncci_manual_classification: hash[:class_code])
    end
  end

  def update_base_rates(base_rate_hash)
    BwcCodesBaseRatesExpLossRate.delete_all

    base_rate_hash.each do |hash|
      BwcCodesBaseRatesExpLossRate.find_or_create_by(class_code: hash[:class_code], base_rate: hash[:base_rate], expected_loss_rate: hash[:expected_loss_rate])
    end
  end

  def update_limited_rates(limited_rates_hash)
    BwcCodesLimitedLossRatio.delete_all

    limited_rates_hash.each do |hash|
      BwcCodesLimitedLossRatio.find_or_create_by(credibility_group: hash[:credibility_number], industry_group: hash[:industry_group], limited_loss_ratio: hash[:loss_ratio])
    end
  end

  def authorize_admin
    return if current_user.admin?
    redirect_to root_path, flash: { alert: 'Admins only!' }
  end
end