# A basic joins table so that a race can have many participants
# Also specifies the lane
class Participant < ApplicationRecord
  belongs_to :race
  belongs_to :student

  validates :lane, presence: true
end
