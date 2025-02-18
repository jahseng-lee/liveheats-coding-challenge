class AddPlacingToParticipant < ActiveRecord::Migration[8.0]
  def change
    add_column :participants, :placing, :integer, null: true
  end
end
