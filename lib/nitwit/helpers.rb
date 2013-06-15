module Nitwit
  module Helpers
    def consumer
      @consumer ||= begin
        key, secret = ENV.values_at('TWITTER_CONSUMER_KEY', 'TWITTER_CONSUMER_SECRET')
        if key && secret
          OAuth::Consumer.new(key, secret, site: "http://api.twitter.com")
        end
      end
    end

    def request_token
      @request_token ||= begin
        token, token_secret = session[:oauth].values_at(:request_token, :request_token_secret)
        if token && token_secret
          OAuth::RequestToken.new(consumer, token, token_secret)
        end
      end
    end

    def access_token
      @access_token ||= begin
        token, token_secret = session[:oauth].values_at(:access_token, :access_token_secret)
        if token && token_secret
          OAuth::AccessToken.new(consumer, token, token_secret)
        end
      end
    end

    def client
      @client ||= begin
        oauth_token, oauth_secret = ENV.values_at('TWITTER_OAUTH_TOKEN', 'TWITTER_OAUTH_SECRET')
        unless oauth_token && oauth_secret
          if access_token
            oauth_token, oauth_secret = access_token.token, access_token.secret
          end
        end
        if oauth_token && oauth_secret
          Twitter::Client.new({
            consumer_key: ENV['TWITTER_CONSUMER_KEY'],
            consumer_secret: ENV['TWITTER_CONSUMER_SECRET'],
            oauth_token: oauth_token,
            oauth_token_secret: oauth_secret
          })
        end
      end
    end

    def my_url
      return ENV['MY_URL'] if ENV['MY_URL']

      url = "#{request.scheme}://#{request.host}"
      port = request.port
      url << ":#{port}" unless [80, 443].include?(port)
      url
    end

    def logged_in?
      !client.nil?
    end
  end
end
