class MrclDetailRecordsController < ApplicationController
  def index
    @mrcl_detail_records = MrclDetailRecord.all
    @mrcl_detail_records_count = MrclDetailRecord.count
  end

  def parse
    MrclDetailRecord.parse_table
    redirect_to root_url, notice: "Step 2 Completed: Mrcl parsed into Mrcl Detail Records. Process Completed."
  end
end
