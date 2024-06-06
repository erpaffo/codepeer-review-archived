class AddFilePathToSnippets < ActiveRecord::Migration[7.1]
  def change
    add_column :snippets, :file_path, :string
  end
end
