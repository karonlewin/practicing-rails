class CreateUserPermissions < ActiveRecord::Migration[5.1]
  def change
    create_table :user_permissions do |t|
      t.references :user, foreign_key: true
      t.string :level
      t.datetime :start
      t.datetime :end
      t.references :sector, foreign_key: true

      t.timestamps
    end
  end
end
