class Race < ApplicationRecord
  has_many :participants

  validates :name, presence: true, uniqueness: true
end
