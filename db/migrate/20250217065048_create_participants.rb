class CreateParticipants < ActiveRecord::Migration[8.0]
  def change
    create_table :participants do |t|
      t.references :student
      t.references :race

      t.timestamps
    end
  end
end
