class CreateEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :employees do |t|
      t.string :code
      t.string :name
      t.string :surnames
      t.string :email
      t.string :status
      t.string :employee_type

      t.timestamps
    end

    add_index :employees, :code, unique: true
  end
end
