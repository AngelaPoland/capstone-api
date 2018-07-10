class RemoveDateFromIntakes < ActiveRecord::Migration[5.1]
  def change
    remove_column :intakes, :date
  end
end
