require 'spec_helper'

describe "FoodItems" do
  describe "GET /food_items" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get food_items_path
      expect(response.status).to be(200)
    end
  end
end
