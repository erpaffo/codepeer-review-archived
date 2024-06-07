class CreateSnippets < ActiveRecord::Migration[7.1]
  def change
    create_table :snippets do |t|
      t.string :title
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
