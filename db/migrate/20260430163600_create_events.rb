class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.references :job_application, null: false, foreign_key: true
      t.string :title
      t.integer :event_type
      t.datetime :scheduled_at
      t.text :notes

      t.timestamps
    end
  end
end
