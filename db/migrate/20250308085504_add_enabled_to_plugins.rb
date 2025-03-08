class AddEnabledToPlugins < ActiveRecord::Migration[8.0]
  def change
    add_column :plugins, :enabled, :boolean, default: false, null: false
  end
end
