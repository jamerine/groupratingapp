class PhmgnDetailRecordsController < ApplicationController
  def index
    @phmgn_detail_records = PhmgnDetailRecord.all
    @phmgn_detail_records_count = PhmgnDetailRecord.count
  end

  def parse
    PhmgnDetailRecord.parse_table
    # redirect_to root_url, notice: "Step 2 Completed: Phmgn parsed into Phmgn Detail Records. Process Completed."
    redirect_to parse_index_path, notice: "The Phmgn has been parsed"
  end

end
