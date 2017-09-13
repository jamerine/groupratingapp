class NotesController < ApplicationController
  before_action :find_note, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def show
  end

  def new
    @account = Account.find(params[:account_id])
    @note = current_user.notes.build
    @categories = Note.categories
  end

  def create
    @account = Account.find(params[:account_id])
    @note = @account.notes.build(note_params)
    @note.assign_attributes(user_id: current_user.id)
    if @note.save
      flash[:notice] = "Notes was created successfully"
      redirect_to account_path(@account)
    else
      flash[:alert] = "There was an error creating note. Please try again."
      render 'new'
    end
  end

  def index
    @account = Account.find(params[:account_id])
    @notes = @account.notes.order(created_at: :desc)
  end

  def edit
    @categories = Note.categories
    authorize @note
  end

  def update
    @note.assign_attributes(note_params)
    if @note.save
      flash[:notice] = "Notes was updated successfully"
      redirect_to account_path(@account)
    else
      flash[:alert] = "There was an error updating note. Please try again."
      redirect_to account_path(@account)
    end
  end

  def destroy
    if @note.destroy
      flash[:notice] = "Notes was deleted successfully"
      redirect_to account_path(@account)
    else
      flash[:alert] = "There was an error creating note. Please try again."
      redirect_to account_path(@account)
    end
  end

  private

  def find_note
    @account = Account.find(params[:account_id])
    @note = @account.notes.find(params[:id])
  end


  def note_params
    params.require(:note).permit(:category, :description, :title, :attachment)
  end

end
