require "etc"
require "yaml"

module Twitter2Mastodon
  class Store
    attr_reader :store

    def initialize(status)
      @status = status
      @id = Digest::MD5.hexdigest @status.message + @status.id.to_s
      @store_file = find_or_create_store
      @store = JSON.parse(File.read(@store_file))
      store_tweet
    end

    def never_been_published?
      @store.none? { |tweet| tweet[0] == @id }
    end

    private

    def find_or_create_store
      file = File.join(Etc.getpwuid.dir, ".twitter2mastodon.json")
      return file if File.exist?(file)

      FileUtils.touch file
      File.write(file, "{}")
    end

    def store_tweet
      return unless never_been_published?

      new_store = @store.merge({ @id => { name: @status.name, message: @status.message, uri: @status.url.to_str } })
      File.write(@store_file, new_store.to_json)
    end
  end
end
