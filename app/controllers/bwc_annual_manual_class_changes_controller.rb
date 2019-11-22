class BwcAnnualManualClassChangesController < ApplicationController
  before_action :set_manual_class, only: [:update, :edit, :destroy]

  def index
    @manual_classes = BwcAnnualManualClassChange.all
  end

  def new
    @manual_class = BwcAnnualManualClassChange.new
  end

  def create
    @manual_class = BwcAnnualManualClassChange.new(permitted_params)

    if @manual_class.save
      flash[:success] = 'Created Successfully!'
      redirect_to action: :index
    else
      flash[:error] = 'Something Went Wrong!'
      render :new
    end
  end

  def edit
  end

  def update
    if @manual_class.update_attributes(permitted_params)
      flash[:success] = 'Updated Successfully!'
      redirect_to action: :index
    else
      flash[:error] = 'Something Went Wrong!'
      render :edit
    end
  end

  def destroy
    if @manual_class.destroy
      flash[:success] = 'Deleted Successfully!'
      redirect_to action: :index
    else
      flash[:error] = 'Something Went Wrong!'
    end
  end

  private

  def permitted_params
    params.require(:manual_class).permit(:manual_class_from, :manual_class_to, :policy_year)
  end

  def set_manual_class
    @manual_class = BwcAnnualManualClassChange.find(params[:id])
  end
end