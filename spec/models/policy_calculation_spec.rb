require 'rails_helper'

RSpec.describe PolicyCalculation, type: :model do

  let(:policy_calculation) { create(:policy_calculation) }

  it { should have_many(:manual_class_calculations) }
  it { should have_many(:claim_calculations) }
  it { should belong_to(:representative) }





end
