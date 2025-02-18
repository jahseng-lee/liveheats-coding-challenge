require 'rails_helper'

RSpec.describe "Races", type: :request do
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
  let!(:race) do
    Race.create!(name: "100m sprint")
  end
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

  describe "GET #index" do
    let!(:race_2) { Race.create!(name: "200m sprint") }

    it "returns a list of all the races" do
      get races_path

      data = JSON.parse(response.body)

      expect(data["status"]).to eq 200
      expect(data["races"]).to contain_exactly(
        {
          "id" => race.id,
          "name" => race.name,
          "status" => race.status
        },
        {
          "id" => race_2.id,
          "name" => race_2.name,
          "status" => race_2.status
        },
      )
    end
  end

  describe "GET #show" do
    it "returns the race and the participants" do
      get race_path(race)

      data = JSON.parse(response.body)

      expect(data["status"]).to eq 200
      expect(data["race"]).to eq({
        "id" => race.id,
        "name" => race.name,
        "status" => race.status,
        "participants" => race.participants.map do |participant|
          {
            "id" => participant.id,
            "name" => participant.student.name,
            "lane" => participant.lane,
            "placing" => participant.placing
          }
        end
      })
    end
  end

  describe "POST #create" do
    let(:name) { "1km run" }

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
          post races_path, params: params
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
          post races_path, params: params
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
          post races_path, params: params
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
          post races_path, params: params
        }.not_to change{
          Race.count
        }

        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT #update" do
    context "with valid parameters" do
      let(:params) do
        {
          race: {
            participants: [
              { id: participant_1.id, placing: 2 },
              { id: participant_2.id, placing: 1 },
            ]
          }
        }
      end

      it "updates the participants with the placings and marks the" \
        "race as complete" do
          expect(participant_1.placing).to eq nil
          expect(participant_2.placing).to eq nil

          put race_path(race), params: params

          data = JSON.parse(response.body)

          expect(participant_1.reload.placing).to eq 2
          expect(participant_2.reload.placing).to eq 1
          expect(race.reload.status).to eq "complete"

          expect(data["status"]).to eq 201
      end
    end

    context "with gaps in placings" do
      let(:params) do
        {
          race: {
            participants: [
              { id: participant_1.id, placing: 1 },
              { id: participant_2.id, placing: 3 },
            ]
          }
        }
      end

      it "does not update the placings or status" do
        put race_path(race), params: params

        data = JSON.parse(response.body)

        expect(participant_1.reload.placing).to eq nil
        expect(participant_2.reload.placing).to eq nil
        expect(race.reload.status).to eq "pending"

        expect(data["status"]).to eq 422
      end
    end

    context "with nil in placings" do
      let(:params) do
        {
          race: {
            participants: [
              { id: participant_1.id, placing: 1 },
              { id: participant_2.id, placing: nil },
            ]
          }
        }
      end

      it "does not update the placings or status" do
        put race_path(race), params: params

        data = JSON.parse(response.body)

        expect(participant_1.reload.placing).to eq nil
        expect(participant_2.reload.placing).to eq nil
        expect(race.reload.status).to eq "pending"

        expect(data["status"]).to eq 422
      end
    end

    context "with invalid placings" do
      let!(:participant_3) do
        Participant.create!(
          student: student_3,
          lane: 3,
          race: race
        )
      end
      let(:params) do
        {
          race: {
            participants: [
              { id: participant_1.id, placing: 1 },
              { id: participant_2.id, placing: 1 },
              { id: participant_2.id, placing: 2 },
            ]
          }
        }
      end

      it "does not update the placings or status" do
        put race_path(race), params: params

        data = JSON.parse(response.body)

        expect(participant_1.reload.placing).to eq nil
        expect(participant_2.reload.placing).to eq nil
        expect(race.reload.status).to eq "pending"

        expect(data["status"]).to eq 422
      end
    end
  end
end
