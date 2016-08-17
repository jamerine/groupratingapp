class ParseFile
  @queue = :parses

  def self.perform(table_name)
    result = ActiveRecord::Base.connection.execute("SELECT public.proc_process_flat_" + table_name + "()")
    result.clear
  end
end
