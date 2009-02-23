class CreateChallenges < ActiveRecord::Migration
  def self.up
    create_table :challenges do |t|
      t.string :name 
      t.integer :level
      t.integer :score
      t.integer :uid
      t.timestamps
    end
    Challenge.create :id => 1001, :name => "Challenge 01", :level => 1, :score => 1, :uid => 1001
    Challenge.create :id => 1002, :name => "Challenge 02", :level => 1, :score => 1, :uid => 1002
    Challenge.create :id => 1003, :name => "Challenge 03", :level => 2, :score => 2, :uid => 1003
    Challenge.create :id => 1004, :name => "Challenge 04", :level => 2, :score => 2, :uid => 1004
    Challenge.create :id => 1005, :name => "Challenge 05", :level => 3, :score => 3, :uid => 1005
    Challenge.create :id => 1006, :name => "Challenge 06", :level => 1, :score => 1, :uid => 1006
    Challenge.create :id => 1007, :name => "Challenge 07", :level => 1, :score => 1, :uid => 1007
    Challenge.create :id => 1008, :name => "Challenge 08", :level => 2, :score => 2, :uid => 1008
    Challenge.create :id => 1009, :name => "Challenge 09", :level => 2, :score => 2, :uid => 1009
    Challenge.create :id => 1010, :name => "Challenge 10", :level => 3, :score => 3, :uid => 1010
    Challenge.create :id => 1011, :name => "Challenge 11", :level => 3, :score => 5, :uid => 1011
  end

  def self.down
    drop_table :challenges
  end
end
