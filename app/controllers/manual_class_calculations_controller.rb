class ManualClassCalculationsController < ApplicationController
  def index
    @policy_calculations = PolicyCalculation.all.paginate(page: params[:page], per_page: 100)
  end

  def show
    @policy_calculation = PolicyCalculation.find_by(id: params[:id])
    @policy_demographics = FinalEmployerDemographicsInformation.find_by(policy_number: @policy_calculation.policy_number)
  end

  def new
    @policy_calculation = PolicyCalculation.new
  end

  def create_manual_class_objects
    Resque.enqueue(ManualClassUpdateCreate)
    redirect_to manual_class_calculations_path, notice: "Manual Classes are queued to update."
  end


 private

  def manual_class_calculation_params
  
  end


end
