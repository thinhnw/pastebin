class CreatePastes < ActiveRecord::Migration[8.0]
  def change
    create_table :pastes do |t|
      t.string :title
      t.string :slug
      t.boolean :private

      t.timestamps
    end
  end
end
