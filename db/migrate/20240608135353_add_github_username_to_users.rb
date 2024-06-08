class AddGithubUsernameToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :github_username, :string
  end
end
