class AddFilenameToActiveStorageAttachments < ActiveRecord::Migration[7.1]
  def change
    add_column :active_storage_attachments, :filename, :string
  end
end
