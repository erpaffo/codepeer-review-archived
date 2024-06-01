class CreateSnippets < ActiveRecord::Migration[7.1]
  def change
    create_table :snippets do |t|

      t.timestamps
    end
  end
end
