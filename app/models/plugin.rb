class Plugin < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :repo_url, presence: true
  validates :branch, presence: true

  scope :enabled, -> { where(enabled: true) }

  def install_plugin
    plugin_path = Rails.root.join("plugins", name)
    system("git clone --depth 1 --branch #{branch} #{repo_url} #{plugin_path}")
  end

  def load_plugin
    return unless enabled?

    plugin_path = Rails.root.join("plugins", name, "plugin.rb")
    load plugin_path if File.exist?(plugin_path)
  end
end
