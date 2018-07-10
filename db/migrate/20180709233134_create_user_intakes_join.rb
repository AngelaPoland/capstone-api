class CreateUserIntakesJoin < ActiveRecord::Migration[5.1]
  def change
    add_reference :intakes, :user, foreign_key: true
  end
end
