require "twitter2mastodon/version"
require "thor"
require "twitter"
require "mastodon"
require "byebug"
require "yaml"
require "twitter2mastodon/status"

module Twitter2mastodon
  class Cli < Thor
    class_option :verbose, type: :boolean, aliases: "-v"
    class_option :configfile, type: :string, aliases: "-c"

    desc "get_last_tweet [USER]", "Get last tweet from a user a toots it!"

    def get_last_tweet(user)
      return unless options[:configfile]

      config_file = File.expand_path(options[:configfile])
      return nil unless File.exist?(config_file)

      configuration = YAML.load_file(config_file)

      twitter = Twitter::REST::Client.new do |config|
        config.consumer_key = configuration["twitter"]["consumer_key"]
        config.consumer_secret = configuration["twitter"]["consumer_secret"]
        config.access_token = configuration["twitter"]["access_token"]
        config.access_token_secret = configuration["twitter"]["access_token_secret"]
      end

      last_twitt = twitter.user_timeline(user).reject(&:retweet?).reject(&:user_mentions?).first

      last_twitt = Twitter2Mastodon::Status.new(last_twitt)

      mastodon = Mastodon::REST::Client.new(base_url: configuration["mastodon"]["base_url"], bearer_token: configuration["mastodon"]["bearer_token"])

      mastodon.create_status(last_twitt.status)
    end

    Cli.start
  end
end
