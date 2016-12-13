class CreateRepresentativesUsers < ActiveRecord::Migration
  def change
    create_table :representatives_users do |t|
      t.references :user, index: true, foreign_key: true
      t.references :representative, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
