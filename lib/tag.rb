class Tag < ActiveRecord::Base
  has_and_belongs_to_many :recipes

  validates :name, uniqueness: { case_sensitive: false }
end
