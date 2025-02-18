class Race < ApplicationRecord
  has_many :participants

  enum :status, { pending: 0, complete: 1 }

  validates :name, presence: true, uniqueness: true
end
