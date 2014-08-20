require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Uber < OmniAuth::Strategies::OAuth2
      DEFAULT_SCOPE = 'profile'

      option :client_options, :site          => 'https://login.uber.com',
                              :authorize_url => '/oauth/authorize',
                              :token_url     => '/oauth/token'

      uid { nil }

      info do
        # Not implemented yet
        {}
      end

      extra do
        # Not implemented yet
        {}
      end

      def raw_info
        @raw_info ||= access_token.params['user'] || {}
      end

      def request_phase
        options[:authorize_params] = {
          :client_id     => options['client_id'],
          :response_type => 'code',
          :scopes        => (options['scope'] || DEFAULT_SCOPE)
        }

        super
      end
    end
  end
end
