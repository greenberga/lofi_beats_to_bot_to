require 'twitter'
require 'open-uri'

class LofiBeatsToBotTo

  GIST_URL = 'https://gist.githubusercontent.com/farisj/732005bb9c6c1eee68ac2df315965286/raw'.freeze

  def all_phrases
    @all_phrases ||= open(GIST_URL).read.split("\n")
  end

  def most_recent_tweet
    twitter.user_timeline('lofihiphop_bots').first.text
  end

  def most_recent_phrase
    most_recent_tweet.match(/lofi hip hop beats - music to .+\/(.+) to/)[1]
  end

  def next_phrase
    first_index = next_phrase_index
    second_index = (first_index + 1) % all_phrases.length

    first = all_phrases[first_index].strip
    second = all_phrases[second_index].strip

    "lofi hip hop beats - music to #{first}/#{second} to"
  end

  def next_phrase_index
    (all_phrases.find_index(most_recent_phrase) + 1) % all_phrases.length
  end

  def tweet
    twitter.update(next_phrase)
  end

  def twitter
    @twitter ||= Twitter::REST::Client.new do |config|
     config.consumer_key = ENV["consumer_key"]
     config.consumer_secret = ENV["consumer_secret"]
     config.access_token = ENV["access_token"]
     config.access_token_secret = ENV["access_token_secret"]
    end
  end
end

exit unless ((Time.now.hour % 2) == 0)

LofiBeatsToBotTo.new.tweet
