class CreateIntakes < ActiveRecord::Migration[5.1]
  def change
    create_table :intakes do |t|
      t.date :date
      t.float :amount

      t.timestamps
    end
  end
end
