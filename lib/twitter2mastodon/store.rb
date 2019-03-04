require "etc"
require "yaml"

module Twitter2Mastodon
  class Store
    def initialize(status)
      @status = status
      @id = Digest::MD5.hexdigest @status.message + @status.id.to_s
      @store = find_or_create_store
      store_tweet
    end

    def never_been_published?
      store_content.none? { |tweet| tweet[0] == @id }
    end

    private

    def find_or_create_store
      file = File.join(Etc.getpwuid.dir, ".twitter2mastodon.json")
      return file if File.exist?(file)

      FileUtils.touch file
      File.write(file, {}.to_s)
    end

    def store_tweet
      return if never_been_published?

      new_store = store_content.merge({ @id => { name: @status.name, message: @status.message, uri: @status.url.to_str } })
      File.write(@store, new_store.to_json)
    end

    def store_content
      JSON.parse(File.read(@store))
    end
  end
end
