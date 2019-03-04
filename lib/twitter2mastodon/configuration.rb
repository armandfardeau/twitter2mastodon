require "twitter"
require "mastodon"

module Twitter2Mastodon
  class Configuration
    attr_reader :mastodon, :twitter

    def initialize(config_file)
      file = File.expand_path(config_file)
      raise ArgumentError, "No file provided" unless File.exist?(file)

      configuration = YAML.load_file(file)

      @twitter = configuration["twitter"]
      @mastodon = configuration["mastodon"]
    end

    def twitter_client
      Twitter::REST::Client.new do |config|
        config.consumer_key = twitter["consumer_key"]
        config.consumer_secret = twitter["consumer_secret"]
        config.access_token = twitter["access_token"]
        config.access_token_secret = twitter["access_token_secret"]
      end
    end

    def mastodon_client
      Mastodon::REST::Client.new(base_url: mastodon["base_url"], bearer_token: mastodon["bearer_token"])
    end
  end
end