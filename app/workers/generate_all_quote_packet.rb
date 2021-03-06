require 'combine_pdf'
require 'net/http'
require 'open-uri'
require 'zip'

class GenerateAllQuotePacket
  include Sidekiq::Worker

  sidekiq_options queue: :generate_all_quote_packet

  def perform(representative_id, user_id, account_ids)
    @representative = Representative.find(representative_id)
    @user = User.find(user_id)

    # temp_file = Tempfile.new(['pdf_stream','.zip'])

    zip_stream = Zip::OutputStream.write_buffer do |zip|
      # Loop through the files we want to zip

      account_ids.each do |account_id|
        @account = Account.find(account_id)

        if @account.quotes.where(program_type: 0).last
          @quote = @account.quotes.where(program_type: 0).last
          # Get the file object
          uri = URI(@quote.quote_generated.url)
          file_obj = Net::HTTP.get(uri) # => String

          # file_obj = open(@quote.quote_generated.url)

          # Give a name to the file and start a new entry
          zip.put_next_entry("quote_#{@account.policy_number_entered}.pdf")

          # Write the file data to zip
          # zip.print file_obj.get.body.read
          zip.print file_obj
        end
      end
    end


    # Rewind the IO stream so we can read it
    zip_stream.rewind

    # Create a temp file for the zip
    tempZip = Tempfile.new(['pdf_stream','.zip'])

    # Write the stringIO data
    tempZip.binmode
    tempZip.write zip_stream.read

    @representative.zip_file = tempZip
    @representative.save!

    tempZip.close
    tempZip.unlink

    QuotePdfExportMailer.quote_pdf_export(representative_id, user_id, account_ids).deliver_later

  end
end
