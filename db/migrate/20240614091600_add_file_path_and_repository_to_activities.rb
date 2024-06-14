class AddFilePathAndRepositoryToActivities < ActiveRecord::Migration[7.1]
  def change
    add_column :activities, :file_path, :string
    add_column :activities, :repository, :string
  end
end
