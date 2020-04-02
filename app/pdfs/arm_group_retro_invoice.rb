class ArmGroupRetroInvoice < PdfReport
  def initialize(quote=[],account=[],policy_calculation=[],view)
    super()
    @quote = quote
    @account = account
    @policy_calculation = policy_calculation
    @view = view


  @group_fees =
    if @quote.fees.nil?
      0
    else
      @quote.fees
    end

   @current_date = DateTime.now.to_date
   invoice

  end

  private

  def invoice
    current_cursor = cursor

    bounding_box([0, current_cursor], :width => 550, :height => 75) do
      representative_logo
    end


    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 275, :height => 100) do
      indent(15) do
        text "#{@account.representative.abbreviated_name.upcase}", size: 10, style: :bold
        text "P. O. Box 880", size: 10, style: :bold
        text "Hilliard, Ohio 43026", size: 10, style: :bold
        text "Phone: (614) 219-1290", size: 10, style: :bold
        text "Fax: (614) 219-1292", size: 10, style: :bold
      end
    end

    bounding_box([300, current_cursor], :width => 200, :height => 75) do
      text "STATEMENT", size: 28, align: :right
      move_down 10
      text "DATE: #{@current_date.strftime("%B %e, %Y")}", align: :right
    end

    move_down 25
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 250, :height => 85) do
      text_box "Bill:", :at => [30, 100], :width => 50, height: 15, size: 10
      text_box "#{@account.name}", :at => [75, 100], :width => 200, height: 15, size: 10
      text_box "To:", :at => [30, 85], :width => 50, height: 25, size: 10
      text_box "#{@account.street_address.titleize} #{@account.street_address_2.titleize}", :at => [75, 85], :width => 200, height: 10, size: 10
      text_box "#{@account.city.titleize}, #{@account.state.upcase} #{@account.zip_code}", :at => [75, 70], :width => 200, height: 10, size: 10
      text_box "Customer ID #: #{ @account.policy_number_entered}-0", :at => [75, 40], :width => 200, height: 10, size: 10

    end
    bounding_box([300, current_cursor], :width => 200, :height => 85) do
      text "<b>COMMENTS:</b> #{@account.representative.quote_year} Group Retro Enrollment", align: :right, inline_format: true
    end



    table table_data, width: bounds.width, :column_widths => {0 => 75, 1 => 285, 2 => 90, 3 => 90 } do
      self.position = :center
      row(0).font_style = :bold
      row(0).align = :center
      row(1).align = :center
      self.cell_style = {:size => 8}
      self.header = true
      row(-1).font_style = :bold
      row(0).background_color = "b1b1b1"
    end
    table table_data_2, :column_widths => {0 => 95, 1 => 88, 2 => 88, 3 => 88, 4 => 90, 5 =>90 } do
      self.position = :center
      row(0).font_style = :bold
      row(0).align = :center
      row(1).align = :center
      self.cell_style = {:size => 8}
      self.header = true
      row(-1).font_style = :bold
      row(0).background_color = "b1b1b1"
    end

    table table_data_3, :column_widths => {0 => 95, 1 => 88, 2 => 88, 3 => 88, 4 => 90, 5 =>90 } do
      row(0).font_style = :bold

      self.cell_style = {:size => 8}
      self.header = true

      row(0).background_color = "b1b1b1"
      row(1).background_color = "FFFFFF"
      row(2).background_color = "e7e7e7"
      row(4).background_color = "e7e7e7"
    end
    move_down 15
    text "Please contact our office if you would like to arrange quarterly or bi-annual payments.", align: :center, size: 8
    move_down 15
    text "Make all checks payable to #{@account.representative.company_name.upcase}", align: :center, size: 9
    move_down 15
    text "Thank you for your business!", align: :center, size: 10, style: :bold

    bounding_box([0, 25], :width => 550, :height => 50) do
      text "Cleveland/Columbus Offices", align: :center, color: "333333"
      text "Telephone (888) 235-8051  |  Fax (614) 219-1292", align: :center, color: "333333"
      text "Workers' Compensation & Unemployment Compensation Specialists", align: :center, color: "333333"
      text "<u>www.alternativeriskmgmt.com</u>", align: :center, color: "333333", inline_format: true
    end
  end
  def table_data
    @data = [["DATE", "DESCRIPTION", "BALANCE", "AMOUNT" ]]
    @data += [[ "#{@current_date.strftime("%-m/%-d/%Y")}", "#{ @account.representative.quote_year} Group Retro Enrollment & TPA Representation", "#{price(@group_fees)}", "#{price(@group_fees)}"]]
  end
  def table_data_2
    @data = [["CURRENT", "1-30 DAYS PAST DUE", "31-60 DAYS PAST DUE", "61-90 DAYS PAST DUE", "OVER 90 DAYS PAST DUE", "AMOUNT DUE" ]]
    @data += [[ "", "", "", "", "", "#{price(@group_fees)}"]]
  end
  def table_data_3
    @data = [[{:content => "REMITTANCE", :colspan => 2}]]
    @data += [[ "Invoice", "",]]
    @data += [[ "Date", "December 31, #{@quote.program_year}",]]
    @data += [[ "Amount Due", "#{price(@group_fees)}",]]
    @data += [[ "Amount Enclosed", "",]]
  end


end
