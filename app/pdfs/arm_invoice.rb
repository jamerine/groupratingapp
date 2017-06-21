class ArmInvoice < PdfReport
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
    bounding_box([0, current_cursor], :width => 550, :height => 100) do
      if [9,10,16].include? @account.representative.id
        image "#{Rails.root}/app/assets/images/minute men hr.jpeg", height: 100
      elsif [2].include? @account.representative.id
        image "#{Rails.root}/app/assets/images/cose_logo.jpg", height: 100
      elsif [17].include? @account.representative.id
        image "#{Rails.root}/app/assets/images/tartan_logo.jpg", height: 100
      else
        image "#{Rails.root}/app/assets/images/logo.png", height: 50
      end

      text_box "INVOICE", :at => [400, 75], :width => 150, height: 25, style: :bold, size: 25
    end


    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 250, :height => 100) do
      text_box "Bill:", :at => [30, 100], :width => 50, height: 15, size: 10
      text_box "#{@account.name}", :at => [75, 100], :width => 200, height: 15, size: 10
      text_box "To:", :at => [30, 85], :width => 50, height: 25, size: 10
      text_box "#{@account.street_address.titleize} #{@account.street_address_2.titleize}", :at => [75, 85], :width => 200, height: 10, size: 10
      text_box "#{@account.city.titleize}, #{@account.state.upcase} #{@account.zip_code}", :at => [75, 70], :width => 200, height: 10, size: 10
    end

    bounding_box([250, current_cursor], :width => 275, :height => 100) do
      text_box "Alternative Risk Management", :at => [75, 100], :width => 200, height: 15, size: 10, style: :bold
      text_box "P. O. Box 880", :at => [75, 85], :width => 200, height: 15, size: 10, style: :bold
      text_box "Hilliard, Ohio 43026", :at => [75, 70], :width => 200, height: 15, size: 10, style: :bold
      text_box "Phone: (614) 219-1290", :at => [75, 55], :width => 200, height: 15, size: 10, style: :bold
      text_box "Fax: (614) 219-1292", :at => [75, 40], :width => 200, height: 15, size: 10, style: :bold
    end

    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 250, :height => 100) do
      text "COMMENTS: #{@account.representative.quote_year} Group Rating", align: :center
      move_down 25
      text "** Enrollment Deadline: 11/1/#{@account.representative.program_year} **", align: :center
      move_down 25
      text "Customer ID: #{ @account.policy_number_entered}-0", align: :center
    end
    bounding_box([250, current_cursor], :width => 275, :height => 100) do
      text "Invoice Date: #{@current_date.strftime("%B %e, %Y")}", align: :center
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

    bounding_box([200, 250], :width => 350, :height => 30) do
      text "Our Group Rating Deadline is now 11/1/#{@account.representative.program_year} for the #{@account.representative.quote_year} Rate year. If you would like to be invoiced at a later date, please call the office to make payment arrangements. Please complete the enclosed questionnaire and return to our office as soon as possible.", size: 7
    end
    move_down 15
    text "Make all checks payable to Alternative Risk Management", align: :center, size: 9
    move_down 15
    text "Thank you for your business!", align: :center, size: 10, style: :bold

  end
  def table_data
    @data = [["DATE", "DESCRIPTION", "BALANCE", "AMOUNT" ]]
    @data += [[ "#{@current_date.strftime("%-m/%-d/%Y")}", "Ohio Workers’ Comp Third Party Representation and #{ @account.representative.quote_year} Group Rating enrollment", "#{price(@group_fees)}", "#{price(@group_fees)}"]]
  end
  def table_data_2
    @data = [["CURRENT", "1-30 DAYS PAST DUE", "31-60 DAYS PAST DUE", "61-90 DAYS PAST DUE", "OVER 90 DAYS PAST DUE", "AMOUNT DUE" ]]
    @data += [[ "", "", "", "", "", "#{price(@group_fees)}"]]
  end
  def table_data_3
    @data = [[{:content => "REMITTANCE", :colspan => 2}]]
    @data += [[ "Invoice", "",]]
    @data += [[ "Date", "Upon Receipt",]]
    @data += [[ "Amount Due", "#{price(@group_fees)}",]]
    @data += [[ "Amount Enclosed", "",]]
  end


end
