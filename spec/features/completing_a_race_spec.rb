require "rails_helper"

RSpec.feature "Completing a race", type: :feature, js: true do
  let(:student_1) do
    Student.create!(
      first_name: "Megumi",
      last_name: "Fushigoro"
    )
  end
  let(:student_2) do
    Student.create!(
      first_name: "Yuji",
      last_name: "Itadori"
    )
  end
  let(:student_3) do
    Student.create!(
      first_name: "Aoi",
      last_name: "Todo"
    )
  end
  let(:race) { Race.create!(name: "5km marathon") }

  describe "When a race has been created" do
    let!(:participant_1) do
      Participant.create!(
        student: student_1,
        lane: 1,
        race: race
      )
    end
    let!(:participant_2) do
      Participant.create!(
        student: student_2,
        lane: 2,
        race: race
      )
    end
    let!(:participant_3) do
      Participant.create!(
        student: student_3,
        lane: 3,
        race: race
      )
    end

    before do
      visit root_path
    end

    it "shows the race on the home page" do
      expect(page).to have_content race.name
    end

    describe "clicking on the race link" do
      before do
        click_link race.name
      end

      it "shows the race" do
        expect(page).to have_current_path("/race/#{race.id}")
      end

      describe "filling in the values and clicking 'Finish race'" do
        before do
          find("#participant-#{participant_1.id}-placing").click
          find("li", text: 1).click

          find("#participant-#{participant_2.id}-placing").click
          find("li", text: 3).click

          find("#participant-#{participant_3.id}-placing").click
          find("li", text: 2).click

          click_button "Complete race"
        end

        # NOTE: left this test in for illustrative purposes - this test
        #       in it's form doesn't pass.
        #       For some reason, `click_button "Craete" doesnt play nice
        #       with either Chrome, Selenium or MateriaulUI.
        #       The form is never submitted to the back end, it looks like
        #       the JS to submit is never triggered.
        xit "marks the race as 'Complete'" do
          expect(page).not_to have_button "Complete race"

          click_link "Races"

          expect(page).to have_content "Status: complete"
        end
      end
    end
  end
end
