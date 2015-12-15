class AddPrivateToInterest < ActiveRecord::Migration
  def change
    add_column :interests, :is_private, :boolean, default: false
  end
end
