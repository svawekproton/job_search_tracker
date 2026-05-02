class CreateJobApplications < ActiveRecord::Migration[8.1]
  def change
    create_table :job_applications do |t|
      t.string :company_name
      t.string :position
      t.integer :status
      t.date :applied_at
      t.string :url
      t.string :location
      t.text :description

      t.timestamps
    end
  end
end
