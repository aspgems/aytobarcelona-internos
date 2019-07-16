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

## Carga de usuarios de IMIPRE
Para cargar la csv hay que: 
1. meterla dentro de la carpeta tmp con el nombre employees.csv 
2. ejecutar bundle exec rake employees:load

Al autenticar con OAUTH comprueba que los campos del csv tengan el estado activo y el tipo T1

Ejemplo de csv:
```
Matricula;Cognoms;Nom;mail;Estat;Tipus d'Empleat
D541383;MIRO MIRANDA;JORDI;jmirom@bcn.cat;ACTIVE;T1
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