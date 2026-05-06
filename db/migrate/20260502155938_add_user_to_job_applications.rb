class AddUserToJobApplications < ActiveRecord::Migration[8.1]
  def up
    # 1. Add the reference as nullable first
    add_reference :job_applications, :user, null: true, foreign_key: true

    # 2. Backfill existing records
    if JobApplication.exists?
      # We attempt to assign orphan records to the first available user.
      # If no users exist, we raise an error to prevent creating an insecure placeholder.
      if User.none?
        raise <<~ERROR
          
          ==============================================================================
          MIGRATION FAILURE: Orphan Job Applications Detected
          ==============================================================================
          The database has existing Job Applications, but no Users exist to own them.
          To ensure data security and integrity, this migration will not create a 
          default "placeholder" account.
          
          ACTION REQUIRED:
          1. Manually create a User via the Rails console (bin/rails c) or seed file.
          2. Re-run this migration.
          ==============================================================================
        ERROR
      end

      # Assign all orphan applications to the first user
      JobApplication.where(user_id: nil).update_all(user_id: User.first.id)
    end

    # 3. Enforce the NOT NULL constraint
    change_column_null :job_applications, :user_id, false
  end

  def down
    remove_reference :job_applications, :user
  end
end
