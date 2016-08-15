class GroupRatingController < ApplicationController
  def index

  end


  def create
    process_representative = params[:process_representative]
    experience_period_lower_date = params[:experience_period_lower_date]
    experience_period_upper_date = params[:experience_period_upper_date]
    current_payroll_period_lower_date = params[:current_payroll_period_lower_date]
    

    GroupRating.step_1(process_representative, experience_period_lower_date, experience_period_upper_date, current_payroll_period_lower_date )
    redirect_to group_rating_index_path, notice: "Step 1 Completed"
  end

  def destroy
  end
end
