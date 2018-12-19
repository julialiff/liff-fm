class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :twitter
      t.string :lastfm

      t.timestamps
    end
  end
end
