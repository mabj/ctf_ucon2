class CreateChallengesUsers < ActiveRecord::Migration
  def self.up
    create_table :challenges_users, :id => false do |t|
			t.integer :user_id
			t.integer :challenge_id
      t.timestamps
    end
		add_index :challenges_users, [:challenge_id, :user_id]
		add_index :challenges_users, :user_id
  end

  def self.down
    drop_table :challenges_users
  end
end
