require "twitter2mastodon/version"
require "thor"
require "byebug"
require "yaml"
require "twitter2mastodon/status"
require "twitter2mastodon/configuration"
require "twitter2mastodon/store"

module Twitter2mastodon
  class Cli < Thor
    class_option :verbose, type: :boolean, aliases: "-v"
    class_option :configfile, type: :string, aliases: "-c"

    desc "get_last_tweet [USER]", "Get last tweet from a user a toots it!"

    def get_last_tweet(user)
      return unless options[:configfile]

      # Configure different client
      configuration = Twitter2Mastodon::Configuration.new(options[:configfile])
      twitter = configuration.twitter_client
      mastodon = configuration.mastodon_client

      # get last tweet and stores it
      last_twitt = twitter.user_timeline(user).reject(&:retweet?).reject(&:user_mentions?).first
      last_twitt = Twitter2Mastodon::Status.new(last_twitt)
      last_tweet = Twitter2Mastodon::Store.new(last_twitt)

      # publish status
      mastodon.create_status(last_twitt.status) if last_tweet.never_been_published?
    end

    Cli.start
  end
end
