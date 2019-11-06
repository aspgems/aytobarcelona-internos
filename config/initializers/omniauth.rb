# frozen_string_literal: true

module OmniAuth
  module Strategies
    # tell OmniAuth to load our strategy
    autoload :Imipre, Rails.root.join('lib', 'imipre_strategy')
  end
end

if Rails.application.secrets.dig(:omniauth, :imipre, :enabled)
  Devise.setup do |config|
    config.omniauth :imipre, scope: Chamber.env.imipre.scope, domain: Chamber.env.imipre.domain
  end

  Decidim::User.omniauth_providers << :imipre
end

if Rails.application.secrets.dig(:omniauth, :saml, :enabled)
  Devise.setup do |config|
    config.omniauth :saml,
                    idp_cert: Chamber.env.saml.idp_cert,
                    idp_sso_target_url: Chamber.env.saml.idp_sso_target_url,
                    sp_entity_id: Chamber.env.saml.sp_entity_id,
                    strategy_class: ::OmniAuth::Strategies::SAML,
                    certificate: Chamber.env.saml.certificate,
                    private_key: Chamber.env.saml.private_key,
                    security: {
                      authn_requests_signed: true,
                      signature_method: XMLSecurity::Document::RSA_SHA256
                    }
  end

  Devise::OmniauthCallbacksController.class_eval do
    skip_before_action :verify_authenticity_token
  end

  Decidim::User.omniauth_providers << :saml
end

OmniAuth.config.logger = Rails.logger
