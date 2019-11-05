# frozen_string_literal: true

require "devise"
require "devise_saml_authenticatable"
require "devise_saml_authenticatable/strategy"
require "decidim/saml/engine"

module Decidim
  module Saml
  end
end

module Devise
  mattr_accessor :decidim_organization

  @@saml_update_resource_hook = proc do |user, saml_response, auth_value|
    saml_response.attributes.resource_keys.each do |key|
      user.send "#{key}=", saml_response.attribute_value_by_resource_key(key)
    end

    user.send "#{saml_default_user_key}=", auth_value if saml_use_subject

    # copied from https://git.io/JezUV

    generated_password = SecureRandom.hex

    if user.persisted?
      user.skip_confirmation! unless user.confirmed?
    else
      user.newsletter_notifications_at = nil
      user.email_on_notification = true
      user.password = generated_password
      user.password_confirmation = generated_password
      user.skip_confirmation!
    end

    user.organization = decidim_organization
    user.nickname = user.email.parameterize
    user.tos_agreement = "1"
    user.save!
  end
end

module SamlAuthenticatableWithDecidimOrganization
  private

  def retrieve_resource
    Devise.decidim_organization = request.env["decidim.current_organization"]

    super
  end
end

module Devise
  module Strategies
    class SamlAuthenticatable < Authenticatable
      prepend SamlAuthenticatableWithDecidimOrganization
    end
  end
end
