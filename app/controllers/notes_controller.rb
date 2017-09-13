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
    @note = @account.notes.build(notes_params)
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

  private

  def find_note
    @account = Account.find(params[:account_id])
    @note = @account.notes.find(params[:id])
  end


  def notes_params
    params.require(:note).permit(:category, :description, :title )
  end

end
