class MatrixGroupRatingInvoice < MatrixPdfReport
  def initialize(quote = [], account = [], policy_calculation = [], view)
    super()
    @quote              = quote
    @account            = account
    @representative     = @account.representative
    @policy_calculation = policy_calculation
    @view               = view
    @group_fees         =
      if @quote.fees.nil?
        0
      else
        @quote.fees
      end
    @current_date       = DateTime.now.to_date

    invoice
  end

  private

  def invoice
    matrix_header
    move_down 15
    current_cursor = cursor

    bounding_box([25, current_cursor], :width => 250, :height => 150) do
      move_down 5
      text 'STATEMENT', size: 24, color: '808080'
      agreement_text "#{@account.policy_number_entered}"
      move_down 2
      agreement_text @account.name
      move_down 2
      agreement_text "#{@account.street_address.upcase} #{@account.street_address_2&.upcase}"
      move_down 2
      agreement_text "#{@account.city.upcase}, #{@account.state.upcase} #{@account.zip_code}"
    end

    bounding_box([bounds.right - 150, current_cursor], :width => 125, :height => 150) do
      move_down 5
      agreement_text @current_date.strftime("%B #{@current_date.day.ordinalize}, %Y"), align: :right
      move_down 20
      agreement_text "Matrix Claims Management Inc.", align: :right
      move_down 2
      agreement_text "Attn: Nedra Nichting", align: :right
      move_down 2
      agreement_text "644 Linn St., Suite 900", align: :right
      move_down 2
      agreement_text "Cincinnati, Ohio 45203", align: :right
      move_down 2
      agreement_text "www.matrixtpa.com", align: :right
      move_down 2
      agreement_text "Phone: 513.351.1222", align: :right
      move_down 2
      agreement_text "Fax: 513.672.0420", align: :right
    end

    text_box 'Remit payment to:', width: 50, style: :bold, size: 8.5, at: [300, current_cursor - 35], align: :right

    table table_data, width: bounds.width - 50 do
      self.position                   = :center
      self.cell_style                 = { :size => 9, inline_format: true }
      self.header                     = true
      self.cells.border_width         = 0.5
      self.cells.border_color         = 'CFCFCF'
      row(-1).font_style              = :bold
      row(0).background_color         = "323E4F"
      row(-1).background_color        = "EFEFEF"
      row(-1).height                  = 20
      row(0..-1).border_top_width     = 0
      row(0..-2).border_bottom_width  = 0
      column(0..1).border_right_color = 'B2B2B2'
      self.row_colors                 = ["FFFFFF", "EFEFEF"]
    end

    move_down 15

    current_cursor = cursor

    bounding_box([30, current_cursor], :width => 95, :height => 110) do
      move_down 12
      stroke { rectangle [0, 76.5], 7, 7 }
      stroke { rectangle [0, 57], 7, 7 }
      stroke { rectangle [0, 36.5], 7, 7 }
      stroke { rectangle [0, 16.5], 7, 7 }

      text 'Payment Information', style: :bold, size: 9

      indent(15) do
        move_down 10
        text 'Check Enclosed', size: 9
        move_down 10
        text 'Visa', size: 9
        move_down 10
        text 'MasterCard', size: 9
        move_down 10
        text 'American Express', size: 9
      end
    end

    table_width = bounds.width - 50 - 10 - 95

    bounding_box([130, current_cursor], :width => table_width) do
      table table_data_2, width: table_width do
        self.position           = :center
        self.cell_style         = { :size => 6, inline_format: true, valign: :center, padding: [5, 5, 10, 5] }
        row(0..2).height        = 25
        row(4).height           = 25
        column(0).width         = 165
        self.cells.border_width = 0.5
        self.cells.border_color = 'CFCFCF'
      end

      move_down 7

      indent(0, 5) do
        text 'You may pay this invoice by check or credit card. Contact us if you wish to be billed at a later date.', align: :right, size: 8
        move_down 5
        text 'By signing this form, you authorize Matrix Claims Management to charge your credit card for the amount shown above and agree to pay the amount shown according to your credit card agreement. A 3% processing fee will be added to all credit card payments.', align: :right, size: 7
      end

      move_down 5

      stroke do
        stroke_color 'CFCFCF'
        horizontal_line 0, table_width, at: cursor
      end
    end

    move_down 20

    indent(25) { text '<i>Thank you for your business!</i>', size: 11, color: '254084', inline_format: true }

    move_down 15

    text "* Note: The Group #{@quote.program_type.to_sym == :group_retro ? 'Retro' : 'Rating'} service fee is based on the most recent historical payroll and claims losses provided by the Ohio BWC and/or the above named employer. The fee may be adjusted pending any changes in payroll. This projection is based on current Ohio BWC data and could be altered or revoked in #{@representative.experience_date.strftime('%m/%d/%y')} experience.", size: 8

    matrix_footer
  end

  def table_data
    @data = [["<color rgb='FFFFFF'>Description</color>", "", "<color rgb='FFFFFF'>Amount</color>"]]
    @data += [["Group Rating service fee for #{@representative.quote_year}", "", { content: "#{price(@group_fees)}", align: :right }]]
    @data += [["OPTIONAL: Safety Assessment", { content: "$350", align: :right }, ""]]
    @data += [["OPTIONAL: Unemployment Claims Management", { content: "", align: :right }, ""]]
    @data += [["OPTIONAL: 10 Background Checks", { content: "", align: :right }, ""]]
    @data += [["", { content: "TOTAL", align: :right }, ""]]
  end

  def table_data_2
    @data = [["Credit Card Number", ""]]
    @data += [["Security Code (3 digit code on back)", ""]]
    @data += [["Expiration Date", ""]]
    @data += [[{ content: "Print Name (as it appears on card)", height: 50 }, ""]]
    @data += [["Signature", ""]]
  end
end
