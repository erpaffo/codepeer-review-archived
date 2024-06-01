class AddOmniauthTokensToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :token, :string
    add_column :users, :refresh_token, :string
  end
end
