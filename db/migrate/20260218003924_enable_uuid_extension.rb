class EnableUuidExtension < ActiveRecord::Migration[8.1]
  def up
    enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")
  end

  def down
    disable_extension "pgcrypto"
  end
end
