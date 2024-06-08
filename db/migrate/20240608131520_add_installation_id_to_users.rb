class AddInstallationIdToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :installation_id, :integer
  end
end
