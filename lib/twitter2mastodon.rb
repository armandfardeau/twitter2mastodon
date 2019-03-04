require "twitter2mastodon/version"
require "thor"
require "byebug"
require "yaml"
require "twitter2mastodon/status"
require "twitter2mastodon/configuration"
require "twitter2mastodon/store"

module Twitter2mastodon
  class Cli < Thor
    class_option :ultraverbose, type: :boolean, aliases: "-V"
    class_option :verbose, type: :boolean, aliases: "-v"
    class_option :configfile, type: :string, aliases: "-c"

    desc "get_last_tweet", "Get last tweet from a user a toots it!"
    method_option :user, type: :string, aliases: "-u"

    def get_last_tweet
      message_count = 0
      return unless options[:configfile]

      # Configure different client
      configuration = Twitter2Mastodon::Configuration.new(options[:configfile])

      puts configuration.inspect if options[:ultraverbose]

      twitter = configuration.twitter_client
      mastodon = configuration.mastodon_client
      @store = Twitter2Mastodon::Store.new

      users = if options[:user]
                [options[:user]]
              else
                configuration.users
              end

      users.each do |user|
        # get last tweet and stores it
        last_twitt = twitter.user_timeline(user).reject(&:retweet?).reject(&:user_mentions?).first
        last_twitt = @store.add_to_store(Twitter2Mastodon::Status.new(last_twitt))

        # publish status
        if last_twitt
          mastodon.create_status(last_twitt.status)
          message_count += 1
          puts "Succefully published #{last_twitt.message}" if options[:ultraverbose]
        else
          puts "No new status has been published" if options[:ultraverbose]
        end
      end

      puts @store.store if options[:ultraverbose]
      return unless options[:verbose]

      if message_count
        puts "Succefully published #{message_count} status"
      else
        puts "No status published as expected"
      end
    end

    Cli.start
  end
end
