require "rails_helper"

RSpec.describe "Home", type: :request do
  describe "GET #index" do
    it "returns 200 OK" do
      get root_path

      expect(response.status).to eq 200
    end
  end
end
