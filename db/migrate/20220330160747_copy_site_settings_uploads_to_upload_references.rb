# frozen_string_literal: true

class CopySiteSettingsUploadsToUploadReferences < ActiveRecord::Migration[6.1]
  def up
    execute <<~SQL
      INSERT INTO upload_references(upload_id, target_type, target_id)
      SELECT value::integer, 'SiteSetting', id
      FROM site_settings
      WHERE data_type = 18
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
