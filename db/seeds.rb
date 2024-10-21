# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb

# Hapus semua data pengeluaran yang ada jika Anda ingin memulai dari awal

# Buat pengguna jika belum ada
User.create(email: 'test1@example.com', password: 'password123')

# Data pengeluaran untuk beberapa bulan
expenses_data = [
  { month: 1, year: 2024, amount: 150000, description: 'Belanja bulanan' },
  { month: 2, year: 2024, amount: 200000, description: 'Makan di luar' },
  { month: 3, year: 2024, amount: 180000, description: 'Biaya transportasi' },
  { month: 4, year: 2024, amount: 220000, description: 'Tagihan listrik' },
  { month: 5, year: 2024, amount: 250000, description: 'Perawatan kendaraan' },
  { month: 6, year: 2024, amount: 300000, description: 'Liburan' },
  { month: 7, year: 2024, amount: 170000, description: 'Belanja pakaian' },
  { month: 8, year: 2024, amount: 190000, description: 'Biaya kesehatan' },
  { month: 9, year: 2024, amount: 230000, description: 'Kegiatan sosial' },
  { month: 10, year: 2024, amount: 250000, description: 'Pengeluaran tidak terduga' }
]

# Sisipkan data pengeluaran ke dalam tabel
expenses_data.each do |data|
  Expense.create(
    user_id: 10, # Mengaitkan pengeluaran dengan pengguna
    amount: data[:amount],
    description: data[:description],
    created_at: DateTime.new(data[:year], data[:month], 1), # Mengatur tanggal
    updated_at: DateTime.now
  )
end

puts "Data pengeluaran telah ditambahkan!"
