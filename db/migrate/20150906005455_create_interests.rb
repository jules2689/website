class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.string :interest_type
      t.string :treatment
      t.string :embed_url
      t.string :url
      t.string :provider
      t.string :title

      t.timestamps
    end
  end
end
