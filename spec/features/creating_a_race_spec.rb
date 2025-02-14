require "rails_helper"

RSpec.feature "Creating a race", type: :feature, js: true do
  before do
    visit root_path
  end

  describe "clicking the 'Create race' button" do
    before do
      click_button "Create race"
    end

    it "shows the form to create a new race" do
      expect(page).to have_content "Creating a new race"
    end
  end
end
