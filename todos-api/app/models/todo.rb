class Todo < ApplicationRecord

  # model association
  has_many :items, dependent: :destroy

  # validations
  validates :title,      presence: true
  validates :created_by, presence: true

end
