class Post < ActiveRecord::Base
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :comments
  has_many :users, through: :comments

accepts_nested_attributes_for :categories, reject_if: proc { |attributes| attributes['name'].blank? }


  # the below overrides the built-in setter of the "accepts..." to prevent dupes

  def categories_attributes=(category_attributes)
    category_attributes.values.each do |category_attribute|
      unless category_attribute["name"].blank?
        category = Category.find_or_create_by(category_attribute)
        self.post_categories.build(category: category) unless self.categories.include?(category)
      end
    end
  end


end
