require 'csv'
namespace :employees do
  desc 'Load employees from csv'
  task :load => :environment do
    csv_text = File.read('tmp/employees.csv')
    csv = CSV.parse(csv_text, headers: true, col_sep: ';');
    csv.each do |row|
      hash = row.to_hash
      employee = Employee.find_or_create_by!(code: hash['Matricula'])
      employee.tap do |employee|
        employee.name = hash['Nom']
        employee.surnames = hash['Cognoms']
        employee.email = hash['mail']
        employee.status = hash['Estat']
        employee.employee_type = hash["Tipus d'Empleat"]
      end.save!
    end
  end
end
