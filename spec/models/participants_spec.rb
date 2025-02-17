require 'rails_helper'

RSpec.describe Participant, type: :model do
  subject do
    described_class.new(
      race: race,
      student: student,
      lane: 1
    )
  end
  let(:race) { Race.create!(name: "100m sprint") }
  let(:student) do
    Student.create!(
      first_name: "Usain",
      last_name: "Bolt"
    )
  end

  describe "validations" do
    context "#lane" do
      it "must be present" do
        subject.assign_attributes(lane: nil)
        expect(subject).not_to be_valid

        subject.assign_attributes(lane: 1)
        expect(subject).to be_valid
      end
    end
  end
end
