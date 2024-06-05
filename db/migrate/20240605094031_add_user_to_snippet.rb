class AddUserToSnippet < ActiveRecord::Migration[7.1]
  def change
    add_column :snippets, :user_id, :integer
    add_index :snippets, :user_id
  end
end
