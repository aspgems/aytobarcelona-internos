# frozen_string_literal: true

module Decidim
  module Saml
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Saml

      initializer "decidim_saml" do
        next unless Rails.application.secrets.dig(:saml, :enabled)

        Decidim::Saml::Engine.add_saml

        ActiveSupport::Reloader.to_run do
          Decidim::Saml::Engine.add_saml
        end
      end

      initializer "decidim_saml_devise" do
        next unless Rails.application.secrets.dig(:saml, :enabled)

        callback = Rails.env.development? ? "http://localhost:3000" : ENV["CALLBACK_ADDRESS"]

        ::Devise.setup do |config|
          config.saml_create_user = true
          config.saml_update_user = true
          config.saml_default_user_key = :email
          config.saml_session_index_key = :session_index
          config.saml_use_subject = true
          config.idp_settings_adapter = nil
          config.saml_configure do |settings|
            settings.assertion_consumer_service_url = "#{callback}/users/saml/auth"
            settings.assertion_consumer_service_binding = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
            settings.name_identifier_format = "urn:oasis:names:tc:SAML:2.0:nameid-format:transient"
            settings.issuer = "#{callback}/users/saml/metadata"
            settings.authn_context = ""
            settings.idp_slo_target_url = ""
            settings.idp_sso_target_url = Rails.application.secrets.dig(:saml, :idp_sso_target_url)
            settings.idp_cert_fingerprint = Rails.application.secrets.dig(:saml, :idp_cert_fingerprint)
            settings.idp_cert_fingerprint_algorithm = "http://www.w3.org/2000/09/xmldsig#sha256"
          end
        end
      end

      def self.add_saml
        ::Decidim::User.extend ::Devise::Models::SamlAuthenticatable::ClassMethods
        ::Decidim::User.include ::Devise::Models::SamlAuthenticatable
        ::Decidim::User.devise_modules.delete(:database_authenticatable)
        ::Decidim::User.devise_modules.unshift(:saml_authenticatable)
      end
    end
  end
end
