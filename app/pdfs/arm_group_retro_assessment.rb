class ArmGroupRetroAssessment < PdfReport
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
    if @account.representative.logo.nil?
      if [9,10,16].include? @account.representative.id
        image "#{Rails.root}/app/assets/images/minute men hr.jpeg", height: 75
      elsif [2].include? @account.representative.id
        image "#{Rails.root}/app/assets/images/cose_logo.jpg", height: 75
      elsif [17].include? @account.representative.id
        image "#{Rails.root}/app/assets/images/tartan_logo.jpg", height: 75
      else
        image "#{Rails.root}/app/assets/images/logo.png", height: 50
      end
    else
      if [9,10,16,2,17].include? @account.representative.id
        if Rails.env.production?
          image open(@account.representative.logo.url), height: 75
        else
          image "#{Rails.root}/app/assets/images/minute men hr.jpeg", height: 75
        end
      else
        if Rails.env.production?
          image open(@account.representative.logo.url), height: 50
        else
          image "#{Rails.root}/app/assets/images/logo.png", height: 50
        end
      end
    end
    move_down 15
    text "#{@quote.quote_year} #{ @account.representative.company_name.upcase } RETRO RETURNS EMPLOYER SAFETY ASSESSMENT", style: :bold, align: :center, size: 10
    move_down 10
    text "#{@account.policy_number_entered} | #{@account.name}", size: 12, style: :bold
    move_down 15
    bounding_box([0, cursor], width: 550) do
      move_down 3
      indent(3) do
        text "Please indicate “Yes” or “No” on this assessment. Answering “No” does not preclude your company from eligibility in this program but one of our safety specialists will assist you in establishing that particular safety plan element prior to the beginning of the policy year.", style: :bold, size: 8
      end
      stroke_bounds
    end
    move_down 15
    indent (15) do
      text "1 – Visible, active senior management leadership", style: :bold, size: 9
      current_cursor = cursor
      indent (40) do
        bounding_box([0, current_cursor], :width => 25, :height => 15) do
          text "Y / N", style: :bold, size: 9
        end
        bounding_box([40, current_cursor], :width => 400, :height => 15) do
          text "Our company has a safety policy statement signed by top management.", size: 9
        end
        current_cursor = cursor
        bounding_box([0, current_cursor], :width => 25, :height => 15) do
          text "Y / N", style: :bold, size: 9
        end
        bounding_box([40, current_cursor], :width => 400, :height => 15) do
          text "We discuss safety processes and improvements regularly during staff and/or employee meetings.", size: 9
        end
      end
    end
    indent (15) do
      text "2 – Employee involvement and recognition", style: :bold, size: 9
      current_cursor = cursor
      indent (40) do
        bounding_box([0, current_cursor], :width => 25, :height => 15) do
          text "Y / N", style: :bold, size: 9
        end
        bounding_box([40, current_cursor], :width => 400, :height => 15) do
          text "We provide employees with safety participation opportunities.", size: 9
        end
      end
    end
    indent (15) do
      text "3 – Medical treatment and return-to-work practices", style: :bold, size: 9
      current_cursor = cursor
      indent (40) do
        bounding_box([0, current_cursor], :width => 25, :height => 15) do
          text "Y / N", style: :bold, size: 9
        end
        bounding_box([40, current_cursor], :width => 400, :height => 25) do
          text "We have developed a written procedure for reporting accidents within a specified time frame and for obtaining medical treatment after a workplace injury.", size: 9
        end
        current_cursor = cursor
        bounding_box([0, current_cursor], :width => 25, :height => 15) do
          text "Y / N", style: :bold, size: 9
        end
        bounding_box([40, current_cursor], :width => 400, :height => 15) do
          text "We have developed a return-to-work policy or statement.", size: 9
        end
      end
    end
    indent (15) do
      text "4 – Communication", style: :bold, size: 9
      current_cursor = cursor
      indent (40) do
        bounding_box([0, current_cursor], :width => 25, :height => 15) do
          text "Y / N", style: :bold, size: 9
        end
        bounding_box([40, current_cursor], :width => 400, :height => 25) do
          text "Our company uses written safety communications to employees. (For example, company newsletter or payroll stuffer).", size: 9
        end
        current_cursor = cursor
        bounding_box([40, current_cursor], :width => 400, :height => 15) do
          text "List the types of written safety communications that you use within your company", size: 9
        end
        move_down 5
        current_cursor = cursor
        bounding_box([40, current_cursor], :width => 400, :height => 5) do
          stroke do
           line(bounds.bottom_right, bounds.bottom_left)
         end
        end
      end
    end
    move_down 3
    indent (15) do
      text "5 – Timely notification of claims", style: :bold, size: 9
      current_cursor = cursor
      indent (40) do
        bounding_box([0, current_cursor], :width => 25, :height => 15) do
          text "Y / N", style: :bold, size: 9
        end
        bounding_box([40, current_cursor], :width => 400, :height => 25) do
          text "When an employee notifies us of an occupational injury or illness, we report the claim to the managed care organization and our third party administrator immediately.", size: 9
        end
      end
    end
    indent (15) do
      text "6 – Accident prevention or facility safety coordinator", style: :bold, size: 9
      current_cursor = cursor
      indent (40) do
        bounding_box([0, current_cursor], :width => 25, :height => 15) do
          text "Y / N", style: :bold, size: 9
        end
        bounding_box([40, current_cursor], :width => 400, :height => 25) do
          text "We have designated an employee as accident prevention coordinator who will work with employees and management to implement safety strategies.", size: 9
        end
        current_cursor = cursor
        indent (40) do
          bounding_box([0, current_cursor], :width => 27, :height => 15) do
            text "Name:", size: 9
          end
          bounding_box([27, current_cursor], :width => 200, :height => 10) do
            stroke do
             line(bounds.bottom_right, bounds.bottom_left)
           end
          end
        end
        move_down 10
        current_cursor = cursor
        indent (40) do
          bounding_box([0, current_cursor], :width => 27, :height => 15) do
            text "Title:", size: 9
          end
          bounding_box([27, current_cursor], :width => 200, :height => 10) do
            stroke do
             line(bounds.bottom_right, bounds.bottom_left)
            end
          end
        end
      end
    end
    indent (15) do
      text "7 – Written orientation and training plan", style: :bold, size: 9
      current_cursor = cursor
      indent (40) do
        bounding_box([0, current_cursor], :width => 25, :height => 15) do
          text "Y / N", style: :bold, size: 9
        end
        bounding_box([40, current_cursor], :width => 400, :height => 25) do
          text "We have developed a written safety and health training plan that documents specific training objectives and instructional procedures.", size: 9
        end
        current_cursor = cursor
        bounding_box([0, current_cursor], :width => 25, :height => 15) do
          text "Y / N", style: :bold, size: 9
        end
        bounding_box([40, current_cursor], :width => 400, :height => 15) do
          text "We train all employees on all relevant safety and health topics at least annually.", size: 9
        end
        current_cursor = cursor
        bounding_box([0, current_cursor], :width => 25, :height => 15) do
          text "Y / N", style: :bold, size: 9
        end
        bounding_box([40, current_cursor], :width => 400, :height => 15) do
          text "We document our safety training and maintain a signed list of attendees.", size: 9
        end
      end
    end
    indent (15) do
      text "8 – Written and communicated safe work practices", style: :bold, size: 9
      current_cursor = cursor
      indent (40) do
        bounding_box([0, current_cursor], :width => 25, :height => 15) do
          text "Y / N", style: :bold, size: 9
        end
        bounding_box([40, current_cursor], :width => 400, :height => 15) do
          text "We have developed general and job specific safe work practices.", size: 9
        end
        current_cursor = cursor
        bounding_box([0, current_cursor], :width => 25, :height => 15) do
          text "Y / N", style: :bold, size: 9
        end
        bounding_box([40, current_cursor], :width => 400, :height => 25) do
          text "We provide employees with a copy of the safe work practices, and they sign a statement indicating they have read the rules and understand their responsibilities.", size: 9
        end
      end
    end
    indent (15) do
      text "9 – Written safety and health policy", style: :bold, size: 9
      current_cursor = cursor
      indent (40) do
        bounding_box([0, current_cursor], :width => 25, :height => 15) do
          text "Y / N", style: :bold, size: 9
        end
        bounding_box([40, current_cursor], :width => 400, :height => 25) do
          text "We have developed a written safety and health statement signed by the top company official, which includes the responsibilities of all employees to maintain a safe workplace.", size: 9
        end
        current_cursor = cursor
        bounding_box([0, current_cursor], :width => 25, :height => 15) do
          text "Y / N", style: :bold, size: 9
        end
        bounding_box([40, current_cursor], :width => 400, :height => 15) do
          text "We review our safety and health policy with all employees at least once a year.", size: 9
        end
      end
    end
    indent (15) do
      text "10 – Recordkeeping and data analysis", style: :bold, size: 9
      current_cursor = cursor
      indent (40) do
        bounding_box([0, current_cursor], :width => 25, :height => 15) do
          text "Y / N", style: :bold, size: 9
        end
        bounding_box([40, current_cursor], :width => 400, :height => 15) do
          text "We keep records of workplace accidents and near-miss incidents.", size: 9
        end
        current_cursor = cursor
        bounding_box([0, current_cursor], :width => 25, :height => 15) do
          text "Y / N", style: :bold, size: 9
        end
        bounding_box([40, current_cursor], :width => 400, :height => 15) do
          text "We manage injuries by identifying accident causes and controlling or eliminating them.", size: 9
        end
      end
    end
    current_cursor = cursor
    bounding_box([75, current_cursor], :width => 225, :height => 45) do
      move_down 25
      stroke_horizontal_rule
      move_down 3
      text "Signature", size: 8, align: :center
    end
    bounding_box([325 , current_cursor], :width => 100, :height => 45) do
      move_down 25
      stroke_horizontal_rule
      move_down 3
      text "Date", size: 8, align: :center
    end
    current_cursor = cursor
    bounding_box([75, current_cursor], :width => 175, :height => 40) do
      move_down 25
      stroke_horizontal_rule
      move_down 3
      text "Title", size: 8, align: :center
    end
    bounding_box([275 , current_cursor], :width => 175, :height => 40) do
      move_down 25
      stroke_horizontal_rule
      move_down 3
      text "Company", size: 8, align: :center
    end



  end

end
