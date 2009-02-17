class CreateUsersChallenges < ActiveRecord::Migration
  def self.up
    create_table :users_challenges, :id => false do |t|
			t.integer :user_id
			t.integer :challenge_id
      t.timestamps
    end
		add_index :users_challenges, [:challenge_id, :user_id]
		add_index :users_challenges, :user_id
  end

  def self.down
    drop_table :users_challenges
  end
end
