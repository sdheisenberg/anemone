require 'redis'

module Anemone
  module Storage
    class Redis2

      MARSHAL_FIELDS = %w(links visited fetched)

      def initialize(opts = {})
        opts.merge!(:thread_safe => true)
        @redis = ::Redis.new(opts)
        @key = opts[:key] || 'anemone'
        @redis.del(@key)
      end

      def [](url)
        rget(url)
      end

      def []=(url, value)
        hash = value.to_hash
        @redis.hset(@key,url.to_s,Marshal.dump(hash))
      end

      def delete(url)
        page = self[url]
        @redis.hdel(@key,url)
        page
      end

      def each
        urls = @redis.hkeys(@key)
        urls.each do |url|
          page = rget(url)
          yield page.url.to_s, page
        end
      end

      def merge!(hash)
        hash.each { |key, value| self[key] = value }
        self
      end

      def size
        @redis.hlen(@key)
      end

      def keys
        @redis.hkeys
      end

      def has_key?(url)
        @redis.hexists(@key,url)
      end

      def close
        @redis.quit
      end

      private

      def load_value(blob)
        hash = Marshal.load(blob)
        Page.from_hash(hash)
      end

      def rget(url)
        hash = @redis.hget(@key,url)
        if !!hash
          load_value(hash)
        end
      end

    end
  end
end
