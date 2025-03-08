class CreatePlugins < ActiveRecord::Migration[8.0]
  def change
    create_table :plugins do |t|
      t.string :name, null: false
      t.string :repo_url, null: false
      t.string :branch, null: false, default: 'main'

      t.timestamps

      t.index :name, unique: true
      t.index :repo_url, unique: true
    end
  end
end
