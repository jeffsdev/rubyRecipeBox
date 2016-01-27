class Recipe < ActiveRecord::Base
  has_many :quantities
  has_many :ingredients, through: :quantities
  has_and_belongs_to_many :tags

  validates :name, presence: true

  before_save(:capitalize)

private

  def capitalize
    self.name = name.split(" ").each { |w| w.capitalize! }.join(" ")
  end
end
