class CreateParticipants < ActiveRecord::Migration[8.0]
  def change
    create_table :participants do |t|
      t.references :student
      t.references :race

      t.integer :lane

      t.timestamps
    end
  end
end
