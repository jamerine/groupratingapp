class ArmGroupRatingQuestionnaire < PdfReport
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

   questionnaire

  end

  private

  def questionnaire
    representative_logo
    move_down 15
    text "GROUP RATING PROGRAM QUESTIONNAIRE", style: :bold, align: :center, size: 14
    move_down 15
    text "All participants in the group rating program sponsored by our alliance with Northeast Ohio Safety Council (NEOSC) must provide the following information.  The requested information may have an impact on your company’s workers’ compensation group rating experience and could impact all of the other employers in the program.", size: 10
    move_down 15
    text "Please complete the following questionnaire and return it to us along with your signed documents.", size: 10
    text "Please complete to the best of your knowledge:  if you don’t know, please mark that you do not know of any such situation.", size: 10
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 550, :height => 15) do
      text_box "Yes", :at => [400, 15], :width => 50, height: 15, style: :bold
      text_box "No", :at => [450, 15], :width => 50, height: 15, style: :bold
    end
    move_down 5
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 550, :height => 50) do
      indent(30) do
        text_box "Is your company a Professional Employer Organization (PEO)? ", :at => [0,50], :width => 350, height: 15, style: :bold, size: 9
        text_box "A PEO, also known as an Employee Leasing Company, is a separate entity that is responsible for workers’ compensation coverage for all or part of your workforce.", :at => [0,35], :width => 350, height: 25, size: 9
      end
      text_box "[   ]", :at => [400, 50], :width => 50, height: 15, style: :bold
      text_box "[   ]", :at => [450, 50], :width => 50, height: 15, style: :bold
    end
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 550, :height => 25) do
      indent(30) do
        text_box "In the past 5 years, has your company had any affiliation with a PEO?", :at => [0,25], :width => 350, height: 15, style: :bold, size: 9
      end
      text_box "[   ]", :at => [400, 25], :width => 50, height: 15, style: :bold
      text_box "[   ]", :at => [450, 25], :width => 50, height: 15, style: :bold
    end

    bounding_box([0, cursor], :width => 550, :height => 25) do
      indent(30) do
        text_box "In the past 5 years, has your company restructured, purchased, merged, or acquired the assets of another company?", :at => [0,25], :width => 350, height: 25, style: :bold, size: 9
      end
      text_box "[   ]", :at => [400, 25], :width => 50, height: 15, style: :bold
      text_box "[   ]", :at => [450, 25], :width => 50, height: 15, style: :bold
    end
    move_down 10
    bounding_box([0, cursor], :width => 550, :height => 25) do
      indent(30) do
        text_box "In the past 5 years, has your company done business in Ohio under a policy number other than the one listed on this document?", :at => [0,25], :width => 350, height: 25, style: :bold, size: 9
      end
      text_box "[   ]", :at => [400, 25], :width => 50, height: 15, style: :bold
      text_box "[   ]", :at => [450, 25], :width => 50, height: 15, style: :bold
    end
    move_down 10
    bounding_box([0, cursor], :width => 550, :height => 35) do
      indent(30) do
        text_box "Does your company currently have a Workers Compensation matter pending before the Court of Common Pleas, the Court of Appeals, or the Supreme Court of Ohio?", :at => [0,35], :width => 350, height: 35, style: :bold, size: 9
      end
      text_box "[   ]", :at => [400, 35], :width => 50, height: 15, style: :bold
      text_box "[   ]", :at => [450, 35], :width => 50, height: 15, style: :bold
    end
    move_down 10
    bounding_box([0, cursor], :width => 550, :height => 25) do
      indent(30) do
        text_box "In the upcoming year, will your company merge with another company or restructure?", :at => [0,25], :width => 350, height: 25, style: :bold, size: 9
      end
      text_box "[   ]", :at => [400, 25], :width => 50, height: 15, style: :bold
      text_box "[   ]", :at => [450, 25], :width => 50, height: 15, style: :bold
    end
    move_down 15
    text "Additional details for any YES answers:"
    stroke do
      horizontal_line 0, 450, :at => 265
      horizontal_line 0, 450, :at => 250
      horizontal_line 0, 450, :at => 235
    end
    move_down 55
    text "Failure to provide accurate information may result in the removal from the group rating program.  Additionally, any misrepresentation of the information listed above may result in the employer reimbursing the other Group Participants for the financial hardship on those employers due to the misrepresentation."

    move_down 15

    text "<b><u>Certification By Employer</b></u>", inline_format: true
    move_down 15
    text "I hereby certify that the information on this page is true to the best of my knowledge."
    move_down 15
    current_cursor = cursor
    bounding_box([0 , current_cursor], :width => 225, :height => 50) do
      move_down 30
      stroke_horizontal_rule
      move_down 3
      text "Signature", size: 8, align: :center
    end

    bounding_box([275 , current_cursor], :width => 125, :height => 50) do
      move_down 30
      stroke_horizontal_rule
      move_down 3
      text "Title", size: 8, align: :center
    end

    bounding_box([425 , current_cursor], :width => 100, :height => 50) do
      move_down 30
      stroke_horizontal_rule
      move_down 3
      text "Date", size: 8, align: :center
    end
    current_cursor = cursor
    bounding_box([0 , current_cursor], :width => 100, :height => 50) do
      move_down 15
      text "#{ @account.policy_number_entered }-0", size: 10, align: :center
      stroke_horizontal_rule
      move_down 3
      text "Policy", size: 8, align: :center
    end
    bounding_box([105 , current_cursor], :width => 200, :height => 50) do
      move_down 15
      text "#{ @account.name }", size: 10, align: :center
      stroke_horizontal_rule
      move_down 3
      text "Company Name", size: 8, align: :center
    end



  end

end
