# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("../lib", __dir__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "decidim-saml"
  s.summary = "A saml component for decidim's participatory processes."
  s.description = s.summary
  s.version = "0.0.1"
  s.authors = %w(ASPgems)
  s.email = %w(sgomez@aspgems.com)

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]

  s.add_dependency "devise"
  s.add_dependency "devise_saml_authenticatable"

  s.add_development_dependency "decidim-dev"
end
