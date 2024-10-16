class AddUserIdToCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :categories, :user_id, :integer
    add_index :categories, :user_id  # Jika ingin menambah index untuk mempercepat pencarian berdasarkan user_id
    add_foreign_key :categories, :users  # Menambahkan foreign key untuk menghubungkan dengan tabel users
  end
end
