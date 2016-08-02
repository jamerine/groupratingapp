class DemocDetailRecordsController < ApplicationController
  def index
    @democ_detail_records = DemocDetailRecord.all
    @democ_detail_records_count = DemocDetailRecord.count
  end

  def parse
    DemocDetailRecord.parse_table
    redirect_to root_url, notice: "Step 2 Completed: Democs parsed into Democ Detail Records. Process Completed."
  end



end
