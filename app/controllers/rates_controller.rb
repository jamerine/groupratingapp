class RatesController < ApplicationController
  require 'csv'
  require 'open-uri'

  def index
    @base_rates    = BwcCodesBaseRatesExpLossRate.all.includes(:bwc_codes_ncci_manual_class)
    @limited_rates = BwcCodesLimitedLossRatio.all
  end

  def create
    base_rates_file    = rates_params[:base_rates_file]
    limited_rates_file = rates_params[:limited_loss_rates_file]

    if base_rates_file.present?
      base_rate_hash = parse_csv(base_rates_file)

      if base_rate_hash.nil?
        flash[:error] = 'Something went wrong on import!'
      else
        update_class_codes(base_rate_hash)
        update_base_rates(base_rate_hash)
        flash[:notice] = 'Successfully Imported File!'
      end
    end

    if limited_rates_file.present?
      limited_rates_hash = parse_limited_csv(limited_rates_file)
    end

    redirect_to action: :index
  end

  private

  def rates_params
    params.require(:rates).permit(:base_rates_file, :limited_loss_rates_file)
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

      rows.each_with_index do |row, index|
        file_data << row if index > 1
      end

      flash[:success] = 'Successfully Imported File!'
      create_import_hash(file_data)
    rescue
      flash[:error] = 'There was an error importing the file.'
    end
  end

  def create_import_hash(file_data)
    file_data.map do |column|
      {
        industry_group:     column[0],
        class_code:         column[1],
        base_rate:          column[2],
        expected_loss_rate: column[6]
      }
    end
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
end