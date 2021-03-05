class McosController < ApplicationController
  before_action :set_mco, only: [:edit, :update, :destroy]

  def index
    @mcos = Mco.all
  end

  def new
    @mco = Mco.new
  end

  def create
    @mco = Mco.new(permitted_params)

    if @mco.save
      redirect_to edit_mco_path(@mco), notice: 'MCO Added Successfully!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @mco.update_attributes(permitted_params)
      redirect_to edit_mco_path(@mco), notice: 'MCO Updated Successfully!'
    else
      render :edit
    end
  end

  def destroy
    if @mco.destroy
      redirect_to mcos_path, notice: 'MCO Deleted Successfully!'
    end
  end

  private

  def permitted_params
    params.require(:mco).permit(:name, :bwc_mco_id)
  end

  def set_mco
    @mco = Mco.find_by(id: params[:id])
  end
end