class RemoveNotesFromTreatments < ActiveRecord::Migration[7.2]
  def change
    remove_column :treatments, :notes, :text
  end
end
