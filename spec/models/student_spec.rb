require 'rails_helper'

RSpec.describe Student, type: :model do
  subject do
    described_class.new(
      first_name: first_name,
      last_name: last_name
    )
  end
  let(:first_name) { "Gojo" }
  let(:last_name) { "Satoro" }

  describe "validations" do
    context "#first_name" do
      it "must be present" do
        subject.assign_attributes(first_name: "")
        expect(subject).not_to be_valid

        subject.assign_attributes(first_name: "Gojo")
        expect(subject).to be_valid
      end
    end

    context "#last_name" do
      it "must be present" do
        subject.assign_attributes(last_name: "")
        expect(subject).not_to be_valid

        subject.assign_attributes(last_name: "Satoro")
        expect(subject).to be_valid
      end
    end
  end
end
