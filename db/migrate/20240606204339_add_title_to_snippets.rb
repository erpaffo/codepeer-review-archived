class AddTitleToSnippets < ActiveRecord::Migration[7.1]
  def change
    add_column :snippets, :title, :string
  end
end
