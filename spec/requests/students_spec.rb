require 'rails_helper'

RSpec.describe "Students", type: :request do
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

  describe "GET /index" do

    it "returns all students" do
      get students_path(format: :json)

      data = JSON.parse(response.body)

      expect(data["students"]).to contain_exactly(
        {
          "id" => student_1.id,
          "first_name" => student_1.first_name,
          "last_name" => student_1.last_name
        },
        {
          "id" => student_2.id,
          "first_name" => student_2.first_name,
          "last_name" => student_2.last_name
        },
      )
    end
  end
end
