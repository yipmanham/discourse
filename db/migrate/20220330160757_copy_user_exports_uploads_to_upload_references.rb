# frozen_string_literal: true

class CopyUserExportsUploadsToUploadReferences < ActiveRecord::Migration[6.1]
  def up
    execute <<~SQL
      INSERT INTO upload_references(upload_id, target_type, target_id)
      SELECT upload_id, 'UserExport', id
      FROM user_exports
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
