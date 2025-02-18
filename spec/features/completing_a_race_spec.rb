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
    before do
      Participant.create!(
        student: student_1,
        lane: 1,
        race: race
      )
      Participant.create!(
        student: student_2,
        lane: 2,
        race: race
      )
      Participant.create!(
        student: student_3,
        lane: 3,
        race: race
      )

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
          pending "TODO"
        end

        it "marks the race as 'Complete'" do
          pending "TODO"
        end
      end
    end
  end
end
