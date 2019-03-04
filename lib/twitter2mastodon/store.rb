require "etc"
require "yaml"

module Twitter2Mastodon
  class Store
    attr_reader :store

    def initialize
      @store_file = find_or_create_store
      @store = JSON.parse(File.read(@store_file))
    end

    def never_been_published?(twitt)
      @store.none? { |tweet| tweet[0] == make_hash(twitt) }
    end

    def add_to_store(tweet_object)
      status = tweet_object
      id = make_hash(tweet_object)

      return nil unless never_been_published?(tweet_object)

      clean_store

      @store[id] = { name: status.name, message: status.message, uri: status.url.to_str }
      File.write(@store_file, @store.to_json)

      tweet_object
    end

    private

    def clean_store
      return unless @store.size > 100

      @store.shift
    end

    def find_or_create_store
      file = File.join(Etc.getpwuid.dir, ".twitter2mastodon.json")
      return file if File.exist?(file)

      FileUtils.touch file
      File.write(file, "{}")
    end

    def make_hash(tweet_object)
      Digest::MD5.hexdigest tweet_object.message + tweet_object.id.to_s
    end
  end
end
