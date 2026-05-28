class AddUserToOwnersAndVets < ActiveRecord::Migration[7.2]
  def change
    add_reference :owners, :user, null: true, foreign_key: true, index: { unique: true }
    add_reference :vets, :user, null: true, foreign_key: true, index: { unique: true }
  end
end
