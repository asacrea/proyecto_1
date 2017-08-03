class CreateMicroposts < ActiveRecord::Migration[5.1]
  def change
    create_table :microposts do |t|
      t.text :name
      t.string :ext
      t.integer :size
      t.integer :user_id

      t.timestamps
    end
  end
end
