class MatrixGroupRetroAssessment < MatrixPdfReport
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
    matrix_header true, true

    text 'Group Retrospective Rating Safety Assessment', style: :bold, size: 10
    text "BWC Policy Number: #{@account.policy_number_entered}", style: :bold, size: 10
    text "Policy Name: #{@account.name.titleize}", style: :bold, size: 10
    move_down 10

    text 'Please answer all questions. Answering \'no\' does not preclude you from eligibility but allows our safety professionals to provide assistance in needed areas prior to the beginning of the policy year.', size: 10
    move_down 10

    indent(15) do
      text '1.    Who handles safety at your company?', style: :bold

      indent(25) do
        text 'Name:'
        stroke_horizontal_rule
        move_down 10
        text 'Title:'
        stroke_horizontal_rule
        move_down 10
        text 'Phone:'
        stroke_horizontal_rule
        move_down 10
        text 'Email:'
        stroke_horizontal_rule
      end
      move_down 20

      current_cursor = cursor
      text '2.    Does your company have a formal written safety plan?', style: :bold
      yes_no_box(current_cursor)
      move_down 15

      current_cursor = cursor
      text '3.    Do you have a safety orienting program?', style: :bold
      yes_no_box(current_cursor)
      current_cursor = cursor
      text_box 'If yes, who conducts it?', style: :bold, inline_format: true, at: [50, current_cursor + 7.5], width: 165
      horizontal_line 165, 400, at: cursor
      stroke

      move_down 20

      current_cursor = cursor
      text '4.    Do you outsource safety training or is it conducted in-house?', style: :bold
      starting_x = 340
      bounding_box([starting_x, current_cursor + 2.5], height: 25, width: 115) do
        text_box 'Outsourced', style: :bold, size: 11, at: [0, 22.5]
        rectangle [70, 25], 15, 15
        stroke
      end

      bounding_box([starting_x + 100, current_cursor + 2.5], height: 25, width: 100) do
        text_box 'In-House', style: :bold, size: 11, at: [0, 22.5]
        rectangle [55, 25], 15, 15
        stroke
      end
      move_down 10

      text '5.    What training is provided to employees?', style: :bold

      bounding_box([20, cursor - 10], width: 400) do
        stroke_horizontal_rule
        move_down 15
        stroke_horizontal_rule
      end

      move_down 20

      current_cursor = cursor
      text '6.    Have you had a safety inspection in the last year?', style: :bold
      yes_no_box(current_cursor)
      text_box 'If yes, by whom?', style: :bold, inline_format: true, at: [50, cursor + 7.5], width: 165
      horizontal_line 135, 400, at: cursor
      stroke

      move_down 20

      current_cursor = cursor
      text '7.    Are you interested in receiving a safety inspection in the near future?', style: :bold
      yes_no_box(current_cursor)
      move_down 25
    end

    current_cursor = cursor
    half_width     = (bounds.width / 2)
    right_column   = half_width + 50

    bounding_box [0, current_cursor], width: half_width do
      inline_text 'Name:'
      horizontal_line 38, right_column - 5, at: 1.5
      stroke
    end

    bounding_box [right_column, current_cursor], width: right_column - 50 do
      inline_text 'Title:'
      horizontal_line 28, bounds.right - 55, at: 1.5
      stroke
    end

    move_down 20

    current_cursor = cursor
    bounding_box [0, current_cursor], width: right_column do
      inline_text "Company Name:     #{@account.name.titleize}"
      horizontal_line 92, right_column - 5, at: 1.5
      stroke
    end

    bounding_box [right_column, current_cursor], width: right_column - 50 do
      inline_text 'Signature:'
      horizontal_line 56, bounds.right - 55, at: 1.5
      stroke
    end


    matrix_footer
  end

  def yes_no_box(current_cursor)
    starting_x = 375
    bounding_box([starting_x, current_cursor + 2.5], height: 25, width: 50) do
      text_box 'Yes', style: :bold, size: 11, at: [0, 22.5]
      rectangle [25, 25], 15, 15
      stroke
    end

    bounding_box([starting_x + 75, current_cursor + 2.5], height: 25, width: 50) do
      text_box 'No', style: :bold, size: 11, at: [0, 22.5]
      rectangle [25, 25], 15, 15
      stroke
    end
  end
end
