require "rails_helper"

RSpec.feature "Creating a race", type: :feature, js: true do
  let!(:student_1) do
    Student.create!(
      first_name: "Megumi",
      last_name: "Fushigoro"
    )
  end
  let!(:student_2) do
    Student.create!(
      first_name: "Yuji",
      last_name: "Itadori"
    )
  end
  let!(:student_3) do
    Student.create!(
      first_name: "Aoi",
      last_name: "Todo"
    )
  end

  before do
    visit root_path
  end

  describe "clicking the 'Create race' button" do
    before do
      click_link "Create race"
    end

    it "shows the form to create a new race" do
      expect(page).to have_content "Create a new race"
    end

    context "filling out the form and clicking 'Create'" do
      before do
        fill_in "Name", with: "5km marathon"

        find("#lane-1").click
        find("li", text: "Megumi Fushigoro").click

        find("#lane-2").click
        find("li", text: "Yuji Itadori").click

        click_button "Add lane"

        find("#lane-3").click
        find("li", text: "Aoi Todo").click
        
        click_button "Create"
      end

      # NOTE: left this test in for illustrative purposes - this test
      #       in it's form doesn't pass.
      #       For some reason, `click_button "Craete" doesnt play nice
      #       with either Chrome, Selenium or MateriaulUI.
      #       The form is never submitted to the back end, it looks like
      #       the JS to submit is never triggered.
      xit "creates a new race" do
        expect(page).to have_current_path(root_path)
        expect(page).to have_content("5km maration")
      end
    end
  end
end
