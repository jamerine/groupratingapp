class ParseProcess
  @queue = :parse_process

  def self.perform(process_representative_id, import_id)


    Resque.enqueue(ParseFile, "democ", import_id)
    Resque.enqueue(ParseFile, "mrcls", import_id)
    Resque.enqueue(ParseFile, "mremp", import_id)
    Resque.enqueue(ParseFile, "pcomb", import_id)
    Resque.enqueue(ParseFile, "phmgn", import_id)
    Resque.enqueue(ParseFile, "sc220", import_id)
    Resque.enqueue(ParseFile, "sc230", import_id)



  end
end
