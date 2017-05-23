require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Uber < OmniAuth::Strategies::OAuth2
      DEFAULT_SCOPE = 'profile'.freeze

      option :client_options, site: 'https://api.uber.com',
                              authorize_url: 'https://login.uber.com/oauth/authorize',
                              token_url: 'https://login.uber.com/oauth/token'

      uid { raw_info['uuid'] }

      info do
        {
          first_name: raw_info['first_name'],
          last_name: raw_info['last_name'],
          email: raw_info['email'],
          picture: raw_info['picture'],
          promo_code: raw_info['promo_code']
        }
      end

      extra do
        {
          raw_info: raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/v1/me').parsed || {}
      end

      def request_phase
        options[:authorize_params] = {
          client_id: options['client_id'],
          response_type: 'code',
          scopes: (options['scope'] || DEFAULT_SCOPE)
        }

        super
      end
    end
  end
end
