class DemocDetailRecordsController < ApplicationController
  def index
    @democ_detail_records = DemocDetailRecord.all
    @democ_detail_records_count = DemocDetailRecord.count
  end

  def parse
    DemocDetailRecord.parse_table
    redirect_to root_url, notice: "Democ parsed."
  end

  

end
