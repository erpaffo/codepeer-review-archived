class AddTwoFactorMethodsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :two_factor_email_enabled, :boolean, default: false
    add_column :users, :two_factor_sms_enabled, :boolean, default: false
    add_column :users, :two_factor_app_enabled, :boolean, default: false
  end
end
