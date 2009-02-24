class CreateChallenges < ActiveRecord::Migration
  def self.up
    create_table :challenges do |t|
      t.string :name 
      t.integer :level
      t.integer :score
      t.integer :uid
      t.timestamps
    end

    Challenge.connection.execute("INSERT into challenges values ('1001', 'challenge 01', '1', '1', 1001, '2009-01-01 01:01:01', '2009-01-01 01:01:01')")
    Challenge.connection.execute("INSERT into challenges values ('1002', 'challenge 02', '1', '1', 1002, '2009-01-01 01:01:01', '2009-01-01 01:01:01')")
    Challenge.connection.execute("INSERT into challenges values ('1003', 'challenge 03', '1', '2', 1003, '2009-01-01 01:01:01', '2009-01-01 01:01:01')")
    Challenge.connection.execute("INSERT into challenges values ('1004', 'challenge 04', '1', '2', 1004, '2009-01-01 01:01:01', '2009-01-01 01:01:01')")
    Challenge.connection.execute("INSERT into challenges values ('1005', 'challenge 05', '1', '3', 1005, '2009-01-01 01:01:01', '2009-01-01 01:01:01')")
    Challenge.connection.execute("INSERT into challenges values ('1006', 'challenge 06', '1', '1', 1006, '2009-01-01 01:01:01', '2009-01-01 01:01:01')")
    Challenge.connection.execute("INSERT into challenges values ('1007', 'challenge 07', '1', '1', 1007, '2009-01-01 01:01:01', '2009-01-01 01:01:01')")
    Challenge.connection.execute("INSERT into challenges values ('1008', 'challenge 08', '1', '2', 1008, '2009-01-01 01:01:01', '2009-01-01 01:01:01')")
    Challenge.connection.execute("INSERT into challenges values ('1009', 'challenge 09', '1', '2', 1009, '2009-01-01 01:01:01', '2009-01-01 01:01:01')")
    Challenge.connection.execute("INSERT into challenges values ('1010', 'challenge 10', '1', '3', 1010, '2009-01-01 01:01:01', '2009-01-01 01:01:01')")
    Challenge.connection.execute("INSERT into challenges values ('1011', 'challenge 11', '1', '5', 1011, '2009-01-01 01:01:01', '2009-01-01 01:01:01')")

  end

  def self.down
    drop_table :challenges
  end
end
