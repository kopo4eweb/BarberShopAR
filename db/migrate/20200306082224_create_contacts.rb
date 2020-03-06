class CreateContacts < ActiveRecord::Migration[6.0]
  def change
     create_table :contacts do |t|
      t.text :email
      t.text :user_message

      t.timestamps
    end
  end
end
