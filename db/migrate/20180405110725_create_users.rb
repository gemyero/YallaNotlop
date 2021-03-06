class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :password_digest
      t.string :email
      t.string :provider, default: 'local'
      t.text :img
      t.timestamps
    end
  end
end
