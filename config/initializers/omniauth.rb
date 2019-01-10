# frozen_string_literal: true

module OmniAuth
  module Strategies
    # tell OmniAuth to load our strategy
    autoload :Imipre, 'lib/omniauth/strategies/imipre'
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :imipre
end
