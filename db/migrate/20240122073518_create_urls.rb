class CreateUrls < ActiveRecord::Migration[7.1]
  def change
    create_table :urls do |t|
      t.string :original_url, null: false
      t.string :short_url, null: false, index: true
      t.integer :clicks, null: false, default: 0

      t.timestamps
    end
  end
end
