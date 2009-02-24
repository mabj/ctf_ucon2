class User < ActiveRecord::Base
	has_and_belongs_to_many :challenges

  def score
    self.challenges.map {|x| x.score }.inject {|a,b| a + b}.to_i
  end
end
