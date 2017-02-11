class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references :user, index: true
      t.references :micropost, index: true

      t.timestamps null: false
    end
  end
end
