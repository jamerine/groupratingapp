class DemocsController < ApplicationController
  # def index
  #   @democs = Democ.all
  #   @democ_count = Democ.count
  #   @democ_detail_records = DemocDetailRecord.all
  #   @democ_detail_records_count = DemocDetailRecord.count
  #   @mrcls = Mrcl.all
  #   @mrcl_count = Mrcl.count
  #   @mremps = Mremp.all
  #   @mremp_count = Mremp.count
  #   @pcombs = Pcomb.all
  #   @pcomb_count = Pcomb.count
  #   @phmgns = Phmgn.all
  #   @phmgn_count = Phmgn.count
  #   @sc220s = Sc220.all
  #   @sc220_count = Sc220.count
  #   @sc230s = Sc230.all
  #   @sc230_count = Sc230.count
  #
  # end
  #
  # def import
  #   time1 = Time.new
  #   puts "Process Start Time: " + time1.inspect
  #   Democ.import_file("https://s3.amazonaws.com/grouprating/ARM/DEMOCFILE")
  #   Mrcl.import_file("https://s3.amazonaws.com/grouprating/ARM/MRCLSFILE")
  #   Mremp.import_file("https://s3.amazonaws.com/grouprating/ARM/MREMPFILE")
  #   Pcomb.import_file("https://s3.amazonaws.com/grouprating/ARM/PCOMBFILE")
  #   Phmgn.import_file("https://s3.amazonaws.com/grouprating/ARM/PHMGNFILE")
  #   Sc220.import_file("https://s3.amazonaws.com/grouprating/ARM/SC220FILE")
  #   Sc230.import_file("https://s3.amazonaws.com/grouprating/ARM/SC230FILE")
  #
  #   redirect_to root_url, notice: "The Democ, Mrcl, Mremp, Pcomb, Phmgn, SC220, and SC230 files have been imported"
  #   time2 = Time.new
  #   puts "Process End Time: " + time2.inspect
  # end
  #
  # def destroy
  #   @democ_detail_records = DemocDetailRecord.all
  #   @democs = Democ.all
  #   @mrcls = Mrcl.all
  #   @mremps = Mremp.all
  #   @pcombs = Pcomb.all
  #   @phmgns = Phmgn.all
  #   @sc220s = Sc220.all
  #   @sc230s = Sc230.all
  #
  #   @democs.delete_all
  #   @mrcls.delete_all
  #   @mremps.delete_all
  #   @pcombs.delete_all
  #   @phmgns.delete_all
  #   @sc220s.delete_all
  #   @sc230s.delete_all
  #
  #   @democ_detail_records.delete_all
  #   # @democs.delete_all
  #   redirect_to root_url, notice: "All files are deleted."
  # end
end
