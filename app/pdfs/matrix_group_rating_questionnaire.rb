class MatrixGroupRatingQuestionnaire < MatrixPdfReport
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

    questionnaire
  end

  private

  def questionnaire
    matrix_header

    text "To: #{@account.name}               Policy Number: #{@account.policy_number_entered}", size: 12
    move_down 15
    text "Thank you for your interest in NEOSC Group Rating Program. All participants in the group rating program sponsored by the Northeast Ohio Safety Council (NEOSC) must provide the following information. The requested information may have an impact on your company’s workers’ compensation group rating experience and could impact all of the other employers in the program.", size: 10
    text 'Please complete the following questionnaire and return it to us along with your signed documents. Please complete to the best of your knowledge: if you don’t know, please mark that you do not know of any such situation.', size: 10
    move_down 15
    text 'If you have any questions, feel free to contact our office.', size: 10

    current_cursor = cursor + 5
    bounding_box([0, current_cursor], :width => 600, :height => 15) do
      text_box "YES", :at => [425, 15], :width => 50, height: 15, style: :bold
      text_box "NO", :at => [475, 15], :width => 50, height: 15, style: :bold
    end

    current_cursor = cursor

    bounding_box([0, current_cursor], :width => 600, :height => 50) do
      indent(30) do
        text_box "Is your company a Professional Employer Organization (PEO)? ", :at => [0, 50], :width => 375, height: 15, style: :bold, size: 10
        text_box "A PEO, also known as an Employee Leasing Company, is a separate entity that is responsible for workers’ compensation coverage for all or part of your workforce.", :at => [0, 35], :width => 375, height: 25, size: 10
      end
      stroked_checkboxes(430, 477.5, 40)
    end

    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 600, :height => 25) do
      indent(30) do
        text_box "In the past 5 years, has your company had any affiliation with a PEO?", :at => [0, 25], :width => 375, height: 15, style: :bold, size: 10
      end
      stroked_checkboxes(430, 477.5, 25)
    end

    bounding_box([0, cursor], :width => 600, :height => 25) do
      indent(30) do
        text_box "In the past 5 years, has your company restructured, purchased, merged, or acquired the assets of another company?", :at => [0, 25], :width => 375, height: 25, style: :bold, size: 10
      end
      stroked_checkboxes(430, 477.5, 25)
    end

    move_down 10
    bounding_box([0, cursor], :width => 600, :height => 25) do
      indent(30) do
        text_box "In the past 5 years, has your company done business in Ohio under a policy number other than the one listed on this document?", :at => [0, 25], :width => 375, height: 25, style: :bold, size: 10
      end
      stroked_checkboxes(430, 477.5, 25)
    end

    move_down 10
    bounding_box([0, cursor], :width => 600, :height => 35) do
      indent(30) do
        text_box "Does your company currently have a Workers Compensation matter pending before the Court of Common Pleas, the Court of Appeals, or the Supreme Court of Ohio?", :at => [0, 35], :width => 375, height: 35, style: :bold, size: 10
      end
      stroked_checkboxes(430, 477.5, 35)
    end

    move_down 10
    bounding_box([0, cursor], :width => 600, :height => 25) do
      indent(30) do
        text_box "In the upcoming year, will your company merge with another company or restructure?", :at => [0, 25], :width => 375, height: 25, style: :bold, size: 10
      end
      stroked_checkboxes(430, 477.5, 25)
    end

    move_down 5
    indent 30 do
      text "Additional details for any YES answers:"
    end

    stroke do
      horizontal_line 30, 490, at: 255
      horizontal_line 30, 490, at: 240
      horizontal_line 30, 490, at: 225
    end

    move_down 50
    text 'Please identify the person in your organization responsible for overseeing your safety program:', size: 10

    indent(-3) do
      table [['Name:', '<u></u>', 'Title:', '<u> </u>'], ['Phone:', '<u> </u>', 'Email:', '<u> </u>']] do
        self.width                           = 490
        self.cells.border_width              = 0
        self.cell_style                      = { padding: [10, 0, 0, 3], inline_format: true, size: 10 }
        self.cells[0, 1].padding             = [0, 0, 0, 0]
        self.cells[0, 1].border_bottom_width = 0.5
        self.cells[0, 3].padding             = [0, 0, 0, 0]
        self.cells[0, 3].border_bottom_width = 0.5
        self.cells[1, 1].padding             = [0, 0, 0, 0]
        self.cells[1, 1].border_bottom_width = 0.5
        self.cells[1, 3].padding             = [0, 0, 0, 0]
        self.cells[1, 3].border_bottom_width = 0.5
        column(0).width                      = 40
        column(2).width                      = 35
      end
    end

    move_down 15
    text "Failure to provide accurate information may result in the removal from the group rating program.  Additionally, any misrepresentation of the information listed above may result in the employer reimbursing the other Group Participants for the financial hardship on those employers due to the misrepresentation."
    text "<u>Certification By Employer</u>", inline_format: true
    move_down 15
    text "I hereby certify that the information on this page is true to the best of my knowledge."
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 225, :height => 50) do
      move_down 20
      stroke_horizontal_rule
      move_down 3
      text "Signature", size: 8
    end

    bounding_box([275, current_cursor], :width => 125, :height => 50) do
      move_down 20
      stroke_horizontal_rule
      move_down 3
      text "Title", size: 8
    end

    bounding_box([425, current_cursor], :width => 100, :height => 50) do
      move_down 20
      stroke_horizontal_rule
      move_down 3
      text "Date", size: 8
    end

    matrix_footer
  end

  def stroked_checkboxes(x1, x2, y)
    stroke do
      rectangle [x1, y], 10, 10
    end
    stroke do
      rectangle [x2, y], 10, 10
    end
  end
end
