require 'rails_helper'

RSpec.describe RepresentativesController, :type => :controller do
  let(:my_representative) { create(:representative ) }

  describe "anonymous user" do
    before :each do
      # This simulates an anonymous user
      login_with nil
    end

    it "should be redirected to signin" do
      get :index
      expect( response ).to redirect_to( new_user_session_path )
    end

    it "should redirect a user to signin for a representative" do
      get :show, {id: my_representative.id}
      expect( response ).to redirect_to( new_user_session_path )
    end
  end

  describe "signed in user" do
    before :each do
      #this simulates a signed in user
      login_with create(:user)
    end

    it "should let a user see all the representatives" do
      get :index
      expect( response ).to render_template( :index )
    end

    it "should let a user see a representative" do
      get :show, {id: my_representative.id}
      expect( response ).to render_template( :show )
    end

  end
end
