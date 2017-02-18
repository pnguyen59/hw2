class Movie < ActiveRecord::Base
    def self.getRatings
        return Movie.pluck(:rating).uniq
    end
end
