class AddLanguageToPastes < ActiveRecord::Migration[8.0]
  def change
    add_column :pastes, :language, :string, default: "plaintext", null: false
  end
end
