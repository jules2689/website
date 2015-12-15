class AddAuthenticationTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :authentication_token, :string

    User.all.map(&:save)
  end
end
