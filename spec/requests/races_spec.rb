require 'rails_helper'

RSpec.describe "Races", type: :request do
  let(:name) { "100m sprint" }
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

  describe "POST #create" do
    context "with valid parameters" do
      let(:params) do
        {
          race: {
            name: name,
            participants: [
              { student_id: student_1.id, lane: 1 },
              { student_id: student_2.id, lane: 2 },
              { student_id: student_3.id, lane: 3 },
            ]
          }
        }
      end

      it "creates a race and returns success" do
        expect{
          post races_path(format: :json), params: params
        }.to change{
          Race.count
        }.by(1)
        .and change{
          Participant.count
        }.by(3)

        race = Race.last

        expect(race.name).to eq name
        expect(race.participants.count).to eq 3

        expect(response.status).to eq 201
      end
    end

    context "with not enough participants" do
      let(:params) do
        {
          race: {
            name: name,
            participants: [
              { student_id: student_1.id, lane: 1 },
            ]
          }
        }
      end

      it "does not create a race" do
        expect{
          post races_path(format: :json), params: params
        }.not_to change{
          Race.count
        }

        expect(response.status).to eq 422
      end
    end

    context "with a participant assigned to multiple lanes" do
      let(:params) do
        {
          race: {
            name: name,
            participants: [
              { student_id: student_1.id, lane: 1 },
              { student_id: student_1.id, lane: 2 },
            ]
          }
        }
      end

      it "does not create a race" do
        expect{
          post races_path(format: :json), params: params
        }.not_to change{
          Race.count
        }

        expect(response.status).to eq 422
      end
    end

    context "with multiple participants assigned to one lanes" do
      let(:params) do
        {
          race: {
            name: name,
            participants: [
              { student_id: student_1.id, lane: 1 },
              { student_id: student_2.id, lane: 1 },
            ]
          }
        }
      end

      it "does not create a race" do
        expect{
          post races_path(format: :json), params: params
        }.not_to change{
          Race.count
        }

        expect(response.status).to eq 422
      end
    end
  end
end
