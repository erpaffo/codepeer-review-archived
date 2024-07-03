class AddFilesToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :files, :string
  end
end
