class AddSlugToPastes < ActiveRecord::Migration[8.0]
  def change
    add_index :pastes, :slug, unique: true
  end
end
