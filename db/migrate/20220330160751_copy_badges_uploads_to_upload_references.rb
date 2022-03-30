# frozen_string_literal: true

class CopyBadgesUploadsToUploadReferences < ActiveRecord::Migration[6.1]
  def up
    execute <<~SQL
      INSERT INTO upload_references(upload_id, target_type, target_id)
      SELECT image_upload_id, 'Badge', id
      FROM badges
      WHERE image_upload_id IS NOT NULL
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
