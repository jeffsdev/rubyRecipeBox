class Recipe < ActiveRecord::Base
  has_many :quantities
  has_many :ingredients, through: :quantities
  has_and_belongs_to_many :tags

  validates :name, presence: true

  before_save(:capitalize)

  def tag_string_to_tags(tag_string)
    tag_names = tag_string.split(', ')
    tag_names.each do |tag_name|
      tag_match = Tag.find_by(name: tag_name)
      if tag_match.nil?
        self.tags.create(name: tag_name)
      else
        self.tags << tag_match
      end
    end
  end

private

  def capitalize
    self.name = name.split(" ").each { |w| w.capitalize! }.join(" ")
  end
end
