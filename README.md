# internos

Free Open-Source participatory democracy, citizen participation and open government for cities and organizations

This is the open-source repository for borrame, based on [Decidim](https://github.com/decidim/decidim).

## Setting up the application

You will need to do some steps before having the app working properly once you've deployed it:

1. Open a Rails console in the server: `bundle exec rails console`
2. Create a System Admin user:
```ruby
user = Decidim::System::Admin.new(email: <email>, password: <password>, password_confirmation: <password>)
user.save!
```
3. Visit `<your app url>/system` and login with your system admin credentials
4. Create a new organization. Check the locales you want to use for that organization, and select a default locale.
5. Set the correct default host for the organization, otherwise the app will not work properly. Note that you need to include any subdomain you might be using.
6. Fill the rest of the form and submit it.

You're good to go!

## SAML integration

The [ruby-saml](https://github.com/onelogin/ruby-saml) gem allows to integrate a SAML single sign on strategy.
It uses the IDP endpoint url and it generates a local route to the metadata endpoint.
This integration does not replace the previous oauth one. The oauth authentication can still be used, but is disabled in favor of SAML.
You can still use the previous oauth authentication strategy just enabling it in the settings, and disabling the SAML one.

 - the IDP endpoint url is provided by the SAML provider and set in the config files
 - the local metadata url is: /users/auth/saml/metadata

Mapped attributes:

  - The saml response contains the different user attributes, and they are mapped automatically with the [omniauth-saml](https://github.com/omniauth/omniauth-saml) gem.
  - Custom attributes are mapped in the config/initializers/omniauth.rb file:

```ruby
                    attribute_statements: {
                      email: ['mail'],
                      name: ['givenName', 'nom']
                    },
```

SAML configuration:

The SAML integration is fully defined in the config/initializers/omniauth.rb file:

```ruby
  Devise.setup do |config|
    config.omniauth :saml,
                    idp_cert: Chamber.env.saml.idp_cert,
                    idp_sso_target_url: Chamber.env.saml.idp_sso_target_url,
                    sp_entity_id: Chamber.env.saml.sp_entity_id,
                    strategy_class: ::OmniAuth::Strategies::SAML,
                    attribute_statements: {
                      email: ['mail'],
                      name: ['givenName', 'nom']
                    },
                    certificate: Chamber.env.saml.certificate,
                    private_key: Chamber.env.saml.private_key,
                    security: {
                      authn_requests_signed: true,
                      signature_method: XMLSecurity::Document::RSA_SHA256
                    }
  end
```

  - idp_cert: is the certificate provided by the IDP provider
  - idp_sso_target_url: is the url provided by the IDP
  - sp_entity_id: is just a identifier to set in the saml response:
      <md:EntityDescriptor xmlns:md="..." xmlns:saml="..." ID="..." entityID="https://decidim.ajuntament.bcn/">
  - attribute_statements: Custom attribute mappings
  - certificate: Certificate used to sign request to the SAML server
  - private_key: Used to sign request to the SAML server

This configuration is set in the config/settings.yml file:

```ruby
  saml:
    idp_sso_target_url: <%= ENV['IDP_SSO_TARGET_URL'] %>
    idp_cert: <%= ENV['IDP_CERT'] %>
    certificate: <%= ENV['CERTIFICATE'] %>
    private_key: <%= ENV['PRIVATE_KEY'] %>
    sp_entity_id: <%= ENV['SP_ENTITY_ID'] %>
    user_types: ['T1', 'T2', 'T3', 'T11']
    cn: 'ACCES'
```


## Carga de usuarios de IMIPRE
Para cargar la csv hay que: 
1. meterla dentro de la carpeta tmp con el nombre employees.csv 
2. ejecutar bundle exec rake employees:load

Al autenticar con OAUTH comprueba que los campos del csv tengan el estado activo y el tipo T1

Ejemplo de csv:
```
Matricula;Cognoms;Nom;mail;Estat;Tipus d'Empleat
DXXXXXX;Sanchez Inclan ;Manuel;msinclan@bcn.cat;ACTIVE;T1
```

## Borrado de respuesta a una encuesta de un usuario

Para obtener el usuario:
u = Decidim::User.where(email: Employee.where(code: 'B611460').first.email).first

Para poder ver el nombre de las encuestas que hay:

Decidim::Surveys::Survey.all.map(&:component)

te quedas con el id del component que se corresponda con la encuesta y obtienes la encuesta

s = Decidim::Surveys::Survey.where(decidim_component_id: 5).last

Obtienes el cuestionario de la encuesta:

q = Decidim::Forms::Questionnaire.includes(:questionnaire_for).where(questionnaire_for: s)

Y obtienes las respuestas al cuestionario del usuario

a = Decidim::Forms::Answer.joins(:questionnaire).where(questionnaire: q).where(decidim_user_id: u.id)

finalmente se borran las respuestas:

a.destroy_all
