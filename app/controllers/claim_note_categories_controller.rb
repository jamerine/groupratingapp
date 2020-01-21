class ClaimNoteCategoriesController < ApplicationController
  before_action :set_category, except: [:index, :new, :create]

  def index
    @categories = ClaimNoteCategory.all
  end

  def new
    @category = ClaimNoteCategory.new
  end

  def create
    @category = ClaimNoteCategory.new(permitted_params)

    if @category.save
      flash[:notice] = 'Category Added Successfully!'
      redirect_to action: :index
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @category.update_attributes(permitted_params)
      flash[:notice] = 'Category Updated Successfully!'
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    if @category.destroy
      flash[:notice] = 'Category Deleted Successfully!'
      redirect_to action: :index
    end
  end

  private

  def permitted_params
    params.require(:claim_note_category).permit(:title, :note)
  end

  def set_category
    @category = ClaimNoteCategory.find(params[:id])
  end
end