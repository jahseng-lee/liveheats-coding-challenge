# A basic joins table so that a race can have many participants
class Participant < ApplicationRecord
  belongs_to :race
  belongs_to :student
end
