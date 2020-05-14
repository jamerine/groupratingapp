class NotesController < ApplicationController
  before_action :find_note, only: [:show, :edit, :update, :destroy, :remove_attachment]
  before_action :authenticate_user!

  def show
  end

  def new
    @account    = Account.find(params[:account_id])
    @note       = current_user.notes.build
    @categories = NoteCategory.all
  end

  def create
    @account         = Account.find(params[:account_id])
    @categories      = NoteCategory.all
    @note            = Note.new(note_params)
    @note.account_id = @account.id
    @note.user_id    = current_user.id

    if @note.save
      flash[:notice] = "Notes was created successfully"
      redirect_to account_path(@account)
    else
      flash[:alert] = "There was an error creating note. Please try again."
      render :new
    end
  end

  def index
    @account    = Account.find(params[:account_id])
    @notes      = @account.notes.order(created_at: :desc)
    @categories = NoteCategory.all
    @users      = []
    @notes.each do |note|
      unless @users.include? note.user
        @users << note.user
      end
    end
    @notes = @notes.category_filter(params[:category_filter]) if params[:category_filter].present?
    @notes = @notes.user_filter(params[:user_filter]) if params[:user_filter].present?
  end

  def edit
    @categories = NoteCategory.all
    authorize @note
  end

  def update
    @categories = NoteCategory.all
    @note.assign_attributes(note_params)
    if @note.save
      flash[:notice] = "Notes was updated successfully"
      redirect_to account_note_path(@account, @note)
    else
      flash[:alert] = "There was an error updating note. Please try again."
      render :edit
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

  def remove_attachment
    @note.remove_attachment!
    if @note.save
      flash[:notice] = "Attachment was deleted successfully"
      redirect_to edit_account_note_path(@account, @note)
    else
      flash[:alert] = "There was an error deleting attachment"
      redirect_to edit_account_note_path(@account, @note)
    end
  end

  private

  def find_note
    @account = Account.find(params[:account_id])
    @note    = @account.notes.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:category_id, :description, :title, :attachment)
  end

end
