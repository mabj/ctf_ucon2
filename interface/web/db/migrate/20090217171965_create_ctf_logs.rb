class CreateCtfLogs < ActiveRecord::Migration
  def self.up
    create_table :ctf_logs do |t|
      t.string :event_name
      t.string :event_description
      t.timestamps
    end
  end

  def self.down
    drop_table :ctf_logs
  end
end
