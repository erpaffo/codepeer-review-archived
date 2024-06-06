class AddModificationsToSnippets < ActiveRecord::Migration[7.1]
  def change
    add_column :snippets, :modifications, :text
  end
end
