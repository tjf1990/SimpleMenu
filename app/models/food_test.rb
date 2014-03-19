class FoodTest < ActiveRecord::Base
  has_paper_trail

  attr_accessible :name, :description, :price, :is_alcoholic
  alias_attribute :to_s, :name
  
  validates_numericality_of :price
  validates_presence_of :name
end

