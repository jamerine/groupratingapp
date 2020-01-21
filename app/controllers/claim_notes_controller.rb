class ClaimNotesController < ApplicationController
  before_action :set_claim_calculation
  before_action :set_note, except: [:new, :create]

  def new
    @note = @claim_calculation.claim_notes.new
  end

  def create
    @note = @claim_calculation.claim_notes.new(permitted_params)

    if @note.save
      redirect_to claim_calculation_path(@claim_calculation), notice: 'Note Added Successfully!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @note.update_attributes(permitted_params)
      redirect_to claim_calculation_path(@claim_calculation), notice: 'Note Updated Successfully!'
    else
      render :edit
    end
  end

  def destroy
    if @note.destroy
      redirect_to claim_calculation_path(@claim_calculation), notice: 'Note Deleted Successfully!'
    end
  end

  private

  def permitted_params
    params.require(:claim_note).permit(:title, :body, :claim_calculation_id, :claim_note_category_id)
  end

  def set_claim_calculation
    @claim_calculation = ClaimCalculation.find(params[:claim_calculation_id])
    @account           = Account.find(@claim_calculation.policy_calculation&.account_id)
  end

  def set_note
    @note = ClaimNote.find(params[:id])
  end
end