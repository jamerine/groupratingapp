class DemocsController < ApplicationController
  def index
    @democs = Democ.all
    @democ_count = Democ.count
    @democ_detail_records = DemocDetailRecord.all
    @democ_detail_records_count = DemocDetailRecord.count
  end

  def import
    Democ.import_file("https://s3.amazonaws.com/grouprating/flat_files/DEMOCFILE")
    redirect_to root_url, notice: "Step 1 Completed: Democs imported. Now parse data."
  end

  def destroy
    @democ_detail_records = DemocDetailRecord.all
    @democs = Democ.all
    @democ_detail_records.delete_all
    @democs.delete_all
    redirect_to root_url, notice: "Democ and Democ Detail Records are deleted."
  end
end
