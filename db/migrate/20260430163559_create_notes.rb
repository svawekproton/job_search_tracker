class CreateNotes < ActiveRecord::Migration[8.1]
  def change
    create_table :notes do |t|
      t.references :job_application, null: false, foreign_key: true
      t.string :category

      t.timestamps
    end
  end
end
