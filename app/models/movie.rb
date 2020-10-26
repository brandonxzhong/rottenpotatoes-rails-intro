class Movie < ActiveRecord::Base
  attr_accessor :all_ratings 
  
  def self.all_ratings
    @all_ratings = Movie.uniq.pluck(:rating)
    @all_ratings
  end 
  
  def self.with_ratings(ratings)
    Movie.where.not(rating: ratings)
  end 
  
end
