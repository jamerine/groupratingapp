class BwcCodesCredibilityMaxLossesController < ApplicationController
  def index
    @max_losses = BwcCodesCredibilityMaxLoss.order(:credibility_group)
  end

  def update_losses
    success = true

    params[:max_losses].each do |max_value|
      max_loss = BwcCodesCredibilityMaxLoss.find_by(id: max_value[:id].to_i)
      if max_loss&.group_maximum_value != max_value[:maximum_value].to_i
        unless max_loss.update_attribute(:group_maximum_value, max_value[:maximum_value].to_i)
          success = false
        end
      end
    end

    success ? flash[:success] = 'Successfully Updated Max Values!' : flash[:error] = 'Something went wrong updating the Max Values!'
    redirect_to action: :index
  end
end