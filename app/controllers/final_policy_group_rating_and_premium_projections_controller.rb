class FinalPolicyGroupRatingAndPremiumProjectionsController < ApplicationController
  def index
    @final_policy_group_rating_and_premium_projections = FinalPolicyGroupRatingAndPremiumProjection.all
  end
end
