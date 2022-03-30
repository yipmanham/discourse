# frozen_string_literal: true

class CopyGroupsUploadsToUploadReferences < ActiveRecord::Migration[6.1]
  def up
    execute <<~SQL
      INSERT INTO upload_references(upload_id, target_type, target_id)
      SELECT flair_upload_id, 'Group', id
      FROM groups
      WHERE flair_upload_id IS NOT NULL
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
