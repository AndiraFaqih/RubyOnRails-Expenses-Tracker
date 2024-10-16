class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :amount, presence: true
  validates :description, presence: true
  validates :user_id, presence: true
end
