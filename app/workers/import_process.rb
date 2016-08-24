class ImportProcess
  @queue = :import_process

  def self.perform(process_representative_id, import_id)

    Resque.enqueue(ImportFile, "https://s3.amazonaws.com/grouprating/ARM/DEMOCFILE", "democs", import_id)
    Resque.enqueue(ImportFile, "https://s3.amazonaws.com/grouprating/ARM/MRCLSFILE", "mrcls", import_id)
    Resque.enqueue(ImportFile, "https://s3.amazonaws.com/grouprating/ARM/MREMPFILE", "mremps", import_id)
    Resque.enqueue(ImportFile, "https://s3.amazonaws.com/grouprating/ARM/PCOMBFILE", "pcombs", import_id)
    Resque.enqueue(ImportFile, "https://s3.amazonaws.com/grouprating/ARM/PHMGNFILE", "phmgns", import_id)
    Resque.enqueue(ImportFile, "https://s3.amazonaws.com/grouprating/ARM/SC220FILE", "sc220s", import_id)
    Resque.enqueue(ImportFile, "https://s3.amazonaws.com/grouprating/ARM/SC230FILE", "sc230s", import_id)

  end

end
