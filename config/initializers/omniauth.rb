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
                    idp_cert_fingerprint: Chamber.env.saml.idp_cert_fingerprint,
                    idp_sso_target_url: Chamber.env.saml.idp_sso_target_url,
                    strategy_class: ::OmniAuth::Strategies::SAML
  end

  Decidim::User.omniauth_providers << :saml
end

OmniAuth.config.logger = Rails.logger
