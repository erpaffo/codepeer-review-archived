class CreateProjectFiles < ActiveRecord::Migration[6.1]
  def change
    create_table :project_files do |t|
      t.string :name
      t.integer :size
      t.string :path
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
