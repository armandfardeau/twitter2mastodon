module Twitter2Mastodon
  class Status
    attr_reader :message, :url, :name

    def initialize(twitt_object)
      @name = twitt_object.user.name
      @message = twitt_object.full_text
      @url = twitt_object.url
    end

    def status
      "#{name}\n\n#{message}\n\nOriginal tweet:#{url}"
    end
  end
end