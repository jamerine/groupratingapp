class ClaimCalculationInformation < PdfReport
  include ActionView::Helpers::NumberHelper

  def initialize(claim_calculation = [], view)
    super()

    @claim_calculation = claim_calculation
    @account           = @claim_calculation.policy_calculation&.account
    @view              = view
    @current_date      = DateTime.current.to_date
    @claim             = @claim_calculation
    @mira              = @claim.mira_detail_record

    header
    stroke_horizontal_rule

    claim_information
    mira_ii_data if @mira.present?
    notes if @claim.claim_notes.any?
  end

  private

  def header
    current_cursor = cursor
    bounding_box([0, current_cursor], :width => 80, :height => 80) do
      representative_logo
      transparent(0) { stroke_bounds }
    end

    bounding_box([100, current_cursor], :width => 350, :height => 65) do
      text @claim.claimant_name.strip, size: 12, style: :bold, align: :center
      move_down 2
      text " Account: #{@account.name.titleize} | Representative: #{@claim.representative_name}", size: 10, align: :center
      move_down 1
      text "Policy Number: #{ @account.policy_number_entered } | Claim Number: #{@claim.claim_number}", size: 10, align: :center
      move_down 1
      text "Claim Information as of #{@claim.updated_at.in_time_zone("America/New_York").strftime("%m/%d/%Y")}", size: 12, align: :center, style: :bold_italic

      transparent(0) { stroke_bounds }
    end
  end

  def claim_information
    pre_current_cursor = cursor

    move_down 10

    current_cursor = cursor

    bounding_box([0, current_cursor], :width => 200, :height => 120) do
      text "Non At Fault: #{ @claim_calculation&.non_at_fault }"
      move_down 2
      text "Injury Type: #{@claim_calculation&.claim_mira_ncci_injury_type }"
      move_down 2
      text "Individual Total Modified Losses: #{number_to_currency(@claim_calculation&.claim_modified_losses_individual_reduced, precision: 0)}"
      move_down 2
      text "Max Value: #{number_to_currency(@claim_calculation&.max_value, precision: 0) }"
      move_down 5
      text "Is Settled: #{ @claim_calculation&.settled_claim }"
      move_down 2
      text "Settlement Type: #{ @claim_calculation&.settlement_type }"
      move_down 2
      text "Medical Settlement Date: #{ @claim_calculation&.medical_settlement_date&.strftime("%b %d, %Y") }"

      transparent(0) { stroke_bounds }
    end

    bounding_box([215, current_cursor], :width => 180, :height => 120) do
      text "Reducible Amount: #{ number_to_currency(@claim_calculation&.claim_mira_reducible_indemnity_paid, precision: 0)}"
      move_down 2

      unless @claim_calculation&.claim_mira_non_reducible_indemnity_paid.zero?
        text "Non Reducible Amount 1: #{ number_to_currency(@claim_calculation&.claim_mira_non_reducible_indemnity_paid, precision: 0)}"
        move_down 2
      end

      unless @claim_calculation&.claim_mira_non_reducible_indemnity_paid_2.zero?
        text "Non Reducible Amount 2: #{ number_to_currency(@claim_calculation&.claim_mira_non_reducible_indemnity_paid_2, precision: 0)}"
      end

      text "Subrogation Percentage: #{ number_to_percentage(@claim_calculation&.claim_subrogation_percent * 100, precision: 0)}"
      move_down 2
      text "Subrogation Amount: #{ number_to_currency(@claim_calculation&.claim_total_subrogation_collected, precision: 0)}"
      move_down 5

      text "Indemnity Settlement Date: #{ @claim_calculation&.indemnity_settlement_date&.strftime("%b %d, %Y") }"
      move_down 2
      text "Indemnity Last Paid Date: #{ @claim_calculation&.indemnity_last_paid_date&.strftime("%b %d, %Y")}"
      move_down 2
      text "Indemnity Reserve: #{ number_to_currency(@claim_calculation&.claim_mira_indemnity_reserve_amount, precision: 0)}"

      transparent(0) { stroke_bounds }
    end

    bounding_box([400, current_cursor], :width => 200, :height => 120) do
      text "Medical Amount Paid: #{ number_to_currency(@claim_calculation&.claim_medical_paid, precision: 0)}"
      move_down 2
      text "Last Medical Paid Date: #{ @claim_calculation&.medical_last_paid_date&.strftime("%b %d, %Y")}"
      move_down 2
      text "Medical Reserve: #{ number_to_currency(@claim_calculation&.claim_mira_medical_reserve_amount, precision: 0)}"
      move_down 5

      text "Handicap Percentage: #{ number_to_percentage(@claim_calculation&.claim_handicap_percent * 100, precision: 0)}"
      move_down 2
      text "Handicap Effective Date: #{ @claim_calculation&.claim_handicap_percent_effective_date&.strftime("%b %d, %Y")}"
      move_down 5

      text "Is Combined: #{ @claim_calculation&.claim_combined}"
      move_down 2
      text "Combined into Claim Number: #{ @claim_calculation&.combined_into_claim_number}"

      transparent(0) { stroke_bounds }
    end

    post_current_cursor = cursor
    stroke do
      # just lower the current y position
      #  horizontal_line 0, 545, :at => current_cursor
      vertical_line (pre_current_cursor), post_current_cursor, :at => 200
      vertical_line (pre_current_cursor), post_current_cursor, :at => 385
      #  horizontal_line 0, 545, :at => 385
    end
    stroke_horizontal_rule
  end

  def mira_ii_data
    move_down 10
    text "Overview and Status:", style: :bold
    move_down 5
    table overview_table, column_widths: { 0 => 144, 1 => 130, 2 => 140, 3 => 125 } do
      row(0..-1).columns(0).font_style = :bold
      row(0..-1).columns(2).font_style = :bold
      row(0..-1).overflow              = :shring_to_fit

      # row(0).borders                = [:bottom]
      # row(1).columns(0..15).borders = []
      # row(0..-1).align = :center
      self.cell_style = { :size => 8 }
      self.header     = false
    end

    move_down 15
    stroke_horizontal_rule

    move_down 10
    text "ICDs:", style: :bold
    move_down 5

    table icds_table, column_widths: { 0 => 144, 1 => 130, 2 => 140, 3 => 125 } do
      row(0).font_style   = :bold
      row(0..-1).overflow = :shring_to_fit

      # row(0).borders                = [:bottom]
      # row(1).columns(0..15).borders = []
      # row(0..-1).align = :center
      self.cell_style = { :size => 8 }
      self.header     = false
    end

    move_down 15
    stroke_horizontal_rule

    move_down 10
    text "Employment:", style: :bold
    move_down 5

    table employment_table, column_widths: { 0 => 270, 1 => 269 } do
      row(0..-1).columns(0).font_style = :bold
      row(0..-1).columns(2).font_style = :bold
      row(0..-1).overflow              = :shring_to_fit

      # row(0).borders                = [:bottom]
      # row(1).columns(0..15).borders = []
      # row(0..-1).align = :center
      self.cell_style = { :size => 8 }
      self.header     = false
    end

    move_down 15
    stroke_horizontal_rule
    move_down 10

    text "Medical:", style: :bold
    move_down 5

    table medical_table, column_widths: { 0 => 144, 1 => 130, 2 => 140, 3 => 125 } do
      row(0..-1).columns(0).font_style = :bold
      row(0..-1).columns(2).font_style = :bold
      row(0..-1).overflow              = :shring_to_fit

      # row(0).borders                = [:bottom]
      # row(1).columns(0..15).borders = []
      # row(0..-1).align = :center
      self.cell_style = { :size => 8 }
      self.header     = false
    end

    move_down 15
    stroke_horizontal_rule
    move_down 10


    text "Indemnity:", style: :bold
    move_down 5

    table indemnity_table, column_widths: { 0 => 144, 1 => 130, 2 => 140, 3 => 125 } do
      row(0..-1).columns(0).font_style = :bold
      row(0..-1).columns(2).font_style = :bold
      row(0..-1).overflow              = :shring_to_fit

      # row(0).borders                = [:bottom]
      # row(1).columns(0..15).borders = []
      # row(0..-1).align = :center
      self.cell_style = { :size => 8 }
      self.header     = false
    end
  end

  def overview_table
    @data = []

    @data << ["Claim Filing Date", @mira.claim_filing_date&.strftime("%b %d, %Y"), 'Claimant Name', @mira.claimant_name]
    @data << ['Gender', @mira.gender, 'Claimant Date of Birth', @mira.claimant_date_of_birth.try(:strftime, "%b %d, %Y")]
    @data << ['Marital Status', @mira.marital_status, 'Date of Injury', @mira.claim_injury_date.try(:strftime, "%b %d, %Y")]
    @data << ['Injured Worker Represented', @mira.injured_worked_represented, 'Age at Injury', @mira.age_at_injury]
    @data << ['Claim Status', @mira.claim_status, 'Claim Manual Number', @mira.claim_manual_number]
    @data << ['Claim Status Effective Date', @mira.claim_status_effective_date&.strftime("%b %d, %Y"), 'Claim Sub Manual Number', @mira.claim_sub_manual_number]
    @data << ['Claim Activity Status', @mira.claim_status_effective_date&.strftime("%b %d, %Y"), 'Industry Code', @mira.industry_code]
    @data << ['Claim Activity Status Effective Date', @mira.claim_activity_status_effective_date&.strftime("%b %d, %Y"), 'Claim Type', @mira.claim_type]
    @data << ['Claimant Zip Code', @mira.claimant_zip_code, 'Claimant Date of Death', @mira.claimant_date_of_death&.strftime("%b %d, %Y")]
    @data << ['Catastrophic Claim', @mira.catastrophic_claim, 'Prediction Status', @mira.prediction_status]
    @data << ['Reduction Amount', @mira.reduction_amount, 'Prediction Close Status Effective Date', @mira.prediction_close_status_effective_date&.strftime("%b %d, %Y")]
    @data << ['Reduction Reason', @mira.reduction_reason, 'Temporary Partial Payments', @mira.temporary_partial_payments]
    @data << ['Temporary Total Payments', @mira.temporary_total_payments, 'Total Reserve Amount For Rates', @mira.total_reserve_amount_for_rates]
  end

  def icds_table
    @data = []
    @data << ['Primary ICD', 'Status', 'Code', 'Injury Location']

    @data += @claim.clicd_detail_records.order(primary_icd: :desc).map do |clicd_detail|
      [clicd_detail&.primary_icd, clicd_detail&.icd_status_display, clicd_detail&.icd_code, clicd_detail&.icd_injury_location_code&.strip]
    end
  end

  def employment_table
    @data = []

    @data << ['Average Weekly Wage', @mira.average_weekly_wage]
    @data << ['Claimant Hire Date', @mira.claim_hire_date&.strftime("%b %d, %Y")]
    @data << ['Salary Continuation', @mira.salary_continuation]
    @data << ['Last Date Worked', @mira.last_date_worked&.strftime("%b %d, %Y")]
    @data << ['Estimated Return To Work Date', @mira.estimated_return_to_work_date&.strftime("%b %d, %Y")]
    @data << ['Return To Work Date', @mira.return_to_work_date&.strftime("%b %d, %Y")]
    @data << ['Injury Or Litigation Type', @mira.injury_or_litigation_type]
    @data << ['Wage Loss Payments', @mira.wage_loss_payments]
  end

  def medical_table
    @data = []

    @data << ['Chiropractor', @mira.chiropractor, 'Medical Drug and Pharmacy Payments', @mira.medical_drug_and_pharmacy_payments]
    @data << ['Physical Therapy', @mira.physical_therapy, 'Medical Emergency Room Payments', @mira.medical_emergency_room_payments]
    @data << ['MMI Date', @mira.mmi_date&.strftime("%b %d, %Y"), 'Medical Funeral Payments', @mira.medical_funeral_payments]
    @data << ['Last Medical Date of Service', @mira.mmi_date&.strftime("%b %d, %Y"), 'Medical Hospital Payments', @mira.medical_hospital_payments]
    @data << ['Total Medical Paid', @mira.total_medical_paid, 'Medical Device Payments', @mira.medical_medical_device_payments]
    @data << ['Total Medical Reserve Amount', @mira.total_medical_reserve_amount, 'Medical Misc. Payments', @mira.medical_misc_payments]
    @data << ['Medical Ambulance Payments', @mira.medical_ambulance_payments, 'Medical Nursing Services Payments', @mira.medical_nursing_services_payments]
    @data << ['Medical Clinic or Nursing Home Payments', @mira.medical_clinic_or_nursing_home_payments, 'Medical Prostheses Device Payments', @mira.medical_prostheses_device_payments]
    @data << ['Medical Court Cost Payments', @mira.medical_court_cost_payments, 'Medical Prostheses Exam Payments', @mira.medical_prostheses_exam_payments]
    @data << ['Medical Doctors Payments', @mira.medical_doctors_payments, 'Medical Travel Payments', @mira.medical_travel_payments]
    @data << ['Medical Reserve Prediction', @mira.medical_reserve_prediction, 'Medical X-Rays And Radiology Payments', @mira.medical_x_rays_and_radiology_payments]
  end

  def indemnity_table
    @data = []

    @data << ['Last Indemnity Period End Date', @mira.mmi_date&.strftime("%b %d, %Y"), 'Indemnity Permanent Partial Payments', @mira.indemnity_permanent_partial_payments]
    @data << ['Indemnity Change of Occupation Payments', @mira.indemnity_change_of_occupation_payments, 'Indemnity Percent Permanent Partial Payments', @mira.indemnity_percent_permanent_partial_payments]
    @data << ['Indemnity Change of Occupation Reserve Prediction', @mira.indemnity_change_of_occupation_reserve_prediction, 'Indemnity Percent Permanent Partial Reserve Prediction', @mira.indemnity_percent_permanent_partial_reserve_prediction]
    @data << ['Indemnity Change of Occupation Reserve Amount', @mira.indemnity_change_of_occupation_reserve_amount, 'Indemnity Percent Permanent Partial Reserve Amount', @mira.indemnity_percent_permanent_partial_reserve_amount]
    @data << ['Indemnity Death Benefit Payments', @mira.indemnity_death_benefit_payments, 'Indemnity PTD Payments', @mira.indemnity_ptd_payments]
    @data << ['Indemnity Death Benefit Reserve Prediction', @mira.indemnity_death_benefit_reserve_prediction, 'Indemnity PTD Reserve Prediction', @mira.indemnity_ptd_reserve_prediction]
    @data << ['Indemnity Death Benefit Reserve Amount', @mira.indemnity_death_benefit_reserve_amount, 'Indemnity PTD Reserve Amount', @mira.indemnity_ptd_reserve_amount]
    @data << ['Indemnity Facial Disfigurement Payments', @mira.indemnity_facial_disfigurement_payments, 'Indemnity Temporary Total Reserve Prediction', @mira.indemnity_temporary_total_reserve_prediction]
    @data << ['Indemnity Facial Disfigurement Reserve Prediction', @mira.indemnity_facial_disfigurement_reserve_prediction, 'Indemnity Temporary Total Reserve Amount', @mira.indemnity_temporary_total_reserve_amount]
    @data << ['Indemnity Facial Disfigurement Reserve Amount', @mira.indemnity_facial_disfigurement_reserve_amount, 'Indemnity Lump Sum Settlement Payments', @mira.indemnity_lump_sum_settlement_payments]
    @data << ['Indemnity Living Maintenance Payments', @mira.indemnity_living_maintenance_payments, 'Indemnity Attorney Fee Payments', @mira.indemnity_attorney_fee_payments]
    @data << ['Indemnity Living Maintenance Wage Loss Payments', @mira.indemnity_living_maintenance_wage_loss_payments, 'Indemnity Other Benefit Payments', @mira.indemnity_other_benefit_payments]
    @data << ['Indemnity Living Maintenance Reserve Prediction', @mira.indemnity_living_maintenance_reserve_prediction, 'Total Indemnity Paid Amount', @mira.total_indemnity_paid_amount]
    @data << ['Indemnity Living Maintenance Reserve Amount', @mira.indemnity_living_maintenance_reserve_amount, 'Total Indemnity Reserve Amount', @mira.total_indemnity_reserve_amount]
  end

  def notes
    move_down 15
    stroke_horizontal_rule
    move_down 10

    text "Notes:", style: :bold
    move_down 5

    table notes_table, column_widths: { 0 => 144, 1 => 130, 2 => 140, 3 => 125 } do
      row(0).font_style   = :bold
      row(0..-1).overflow = :shring_to_fit

      # row(0).borders                = [:bottom]
      # row(1).columns(0..15).borders = []
      # row(0..-1).align = :center
      self.cell_style = { :size => 8 }
      self.header     = false
    end
  end

  def notes_table
    @data = []
    @data << %w(Title Category Note)

    @data += @claim.claim_notes.map do |note|
      [note.title, note.claim_note_category&.title, note.body&.html_safe]
    end
  end
end