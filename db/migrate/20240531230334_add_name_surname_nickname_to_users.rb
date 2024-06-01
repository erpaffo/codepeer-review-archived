class AddNameSurnameNicknameToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :name, :string
    add_column :users, :surname, :string
    add_column :users, :nickname, :string
  end
end
