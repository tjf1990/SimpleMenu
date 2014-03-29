class FoodItem < ActiveRecord::Base
  attr_accessible :name, :description, :price, :is_alcoholic
  alias_attribute :to_s, :name
  has_paper_trail
  
  validates_numericality_of :price
  validates_presence_of :name
end

