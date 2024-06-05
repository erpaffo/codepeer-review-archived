class CreateProjectsUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :projects_users, id: false do |t|
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
    end
  end
end
