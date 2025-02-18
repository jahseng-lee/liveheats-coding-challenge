class AddStatusToRaces < ActiveRecord::Migration[8.0]
  def change
    add_column :races, :status, :integer, default: 0
  end
end
