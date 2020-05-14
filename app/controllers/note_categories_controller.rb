class NoteCategoriesController < ApplicationController
  before_action :set_category, except: [:index, :new, :create]

  def index
    @categories = NoteCategory.all
  end

  def new
    @category = NoteCategory.new
  end

  def create
    @category = NoteCategory.new(permitted_params)

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
    params.require(:note_category).permit(:title)
  end

  def set_category
    @category = NoteCategory.find(params[:id])
  end
end