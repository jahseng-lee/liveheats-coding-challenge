class CreateStudents < ActiveRecord::Migration[8.0]
  def change
    create_table :students do |t|
      t.text :first_name, null: false
      t.text :last_name, null: false

      t.timestamps
    end
  end
end
