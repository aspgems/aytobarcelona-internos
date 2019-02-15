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

OmniAuth.config.logger = Rails.logger
