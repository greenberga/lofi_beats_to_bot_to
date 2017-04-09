require 'twitter'
require 'open-uri'

class BotMeDaddy

  GIST_URL = 'https://gist.githubusercontent.com/farisj/732005bb9c6c1eee68ac2df315965286/raw'.freeze

  def all_phrases
    @all_phrases ||= open(GIST_URL).read.split("\n")
  end

  def most_recent_tweet
    twitter.user_timeline('bot_me_daddy').first.text
  end

  def most_recent_phrase
    phrase = most_recent_tweet.match(/(.+) daddy/)[1]
    if phrase.scan(/.+ me$/).length != 0
      phrase = phrase[0..-4]
    end
    phrase
  end

  def next_phrase
    phrase = all_phrases[all_phrases.find_index(most_recent_phrase) + 1].strip
    unless phrase.include?(" me ")
      phrase += " me"
    end
    phrase + " daddy"
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

BotMeDaddy.new.tweet
