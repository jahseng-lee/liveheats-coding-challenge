require 'rails_helper'

RSpec.describe Race, type: :model do
  subject do
    described_class.new(
      name: name
    )
  end
  let(:name) { "200m race" }

  describe "validations" do
    context "#name" do
      it "must be present" do
        subject.assign_attributes(name: "")
        expect(subject).not_to be_valid

        subject.assign_attributes(name: "200m race")
        expect(subject).to be_valid
      end
    end
  end
end
