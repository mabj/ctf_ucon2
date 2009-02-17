class CreateChallenges < ActiveRecord::Migration
  def self.up
    create_table :challenges do |t|
			t.string :name 
			t.integer :level
			t.integer :score
			t.integer :uid     
      t.timestamps
    end
  end

  def self.down
    drop_table :challenges
  end
end
