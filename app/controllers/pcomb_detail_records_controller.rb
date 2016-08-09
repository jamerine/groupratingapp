class PcombDetailRecordsController < ApplicationController
  def index
    @pcomb_detail_records = PcombDetailRecord.all
    @pcomb_detail_records_count = PcombDetailRecord.count
  end

  def parse
    PcombDetailRecord.parse_table
    redirect_to root_url, notice: "Step 2 Completed: Pcomb parsed into Pcomb Detail Records. Process Completed."
  end

end
