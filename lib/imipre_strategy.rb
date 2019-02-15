# frozen_string_literal: true

require 'omniauth-oauth2'
require 'open-uri'

module OmniAuth
  module Strategies
    # Omniauth client for Imipre
    class Imipre < OmniAuth::Strategies::OAuth2
      option :name, :imipre
      option :client_id, Chamber.env.imipre.client_id
      option :client_secret, Chamber.env.imipre.client_secret
      option :site, Chamber.env.imipre.site
      option :client_options, {}
      option :redirect_uri, Chamber.env.imipre.redirect_uri

      def authorize_params
        super.tap do |params|
          params[:scope] = Chamber.env.imipre.scope
        end
      end

      def build_access_token
        options.token_params.merge!(headers: { 'X-OAUTH-IDENTITY-DOMAIN-NAME': 'IMIPRE' })
        super
      end

      uid do
        raw_info['sub']
      end

      # TODO: Check raw info content for user type
      info do
        {
          email: "#{raw_info['sub']}@imipre.com",
          name: raw_info['sub']
        }
      end

      def client
        options.client_options[:site] = options.site
        options.client_options[:authorize_url] = authorize_url
        options.client_options[:token_url] = token_url
        super
      end

      def raw_info
        access_token.options[:mode]= :query
        @raw_info ||= access_token.get(Chamber.env.imipre.info_url, {headers: { 'X-OAUTH-IDENTITY-DOMAIN-NAME': 'IMIPRE' }}
        ).parsed
      end

      # https://github.com/intridea/omniauth-oauth2/issues/81
      def callback_url
        full_host + script_name + callback_path
      end

      private

      def authorize_url
        @authorize_url ||= URI.join(
          options.site,
          '/oauth2/rest/authz?response_type=code'\
          "&client_id=#{options.client_id}"\
          "&domain=#{Chamber.env.imipre.domain}"\
          "&scope=#{Chamber.env.imipre.scope}"\
          "&redirect_uri=#{Chamber.env.imipre.redirect_uri}"
        ).to_s
      end

      def token_url
        @token_url ||= URI.join(
          options.site,
          "/oauth2/rest/token?grant_type=AUTHORIZATION_CODE&code="
        ).to_s
      end
    end
  end
end
