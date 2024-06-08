class AddContentToSnippets < ActiveRecord::Migration[7.1]
  def change
    add_column :snippets, :content, :text
  end
end
