require_relative "../../infrastructure/db/categories_repository_impl"

class CategoriesUsecase
  def initialize(categoryRepository = CategoriesRepositoryImpl.new)
    @categoryRepository = categoryRepository
  end

  def createCategory(attributes)
    begin
      # Cek apakah kategori dengan nama yang sama sudah ada
      existingCategory = @categoryRepository.find_by_name(attributes[:name])

      if existingCategory
        raise StandardError.new("Kategori dengan nama '#{attributes[:name]}' sudah ada.")
      elsif attributes[:name].empty? || attributes[:description].empty?
        raise StandardError.new("Nama dan deskripsi kategori tidak boleh kosong.")
      else
        # Jika kategori belum ada, buat kategori baru
        category = @categoryRepository.createCategory(attributes)
        category
      end
    rescue StandardError => e
      raise e # Mengangkat kembali error yang sama
    end
  end

  def getCategories(user_id)
    begin
      categories = @categoryRepository.findAllCategories(user_id)

      if categories.empty?
        { message: "Kategori masih kosong." }
      else
        categories
      end
    rescue ActiveRecord::RecordNotFound
      raise StandardError.new("Kategori tidak ditemukan.")
    end
  end

  def getCategoryById(id)
    begin
      category = @categoryRepository.findCategoryById(id)
      category # Mengembalikan kategori jika ditemukan
    rescue ActiveRecord::RecordNotFound
      raise StandardError.new("Kategori dengan ID #{id} tidak ditemukan.")
    end
  end

  def getCategoryByName(name, user_id)
    begin
      category = @categoryRepository.find_by_name(name)
      category # Mengembalikan kategori jika ditemukan
    rescue ActiveRecord::RecordNotFound
      raise StandardError.new("Kategori dengan nama '#{name}' tidak ditemukan.")
    end
  end

  def updateCategory(id, attributes)
    begin
      attributes_to_update = {}
      attributes_to_update[:name] = attributes[:name] if attributes[:name].present?
      attributes_to_update[:description] = attributes[:description] if attributes[:description].present?

      @categoryRepository.updateCategory(id, attributes_to_update)
    rescue ActiveRecord::RecordNotFound
      raise StandardError.new("Kategori dengan ID #{id} tidak ditemukan.")
    end
  end

  def deleteCategory(id)
    begin
      @categoryRepository.findCategoryById(id)
      @categoryRepository.destroyCategory(id) # Hapus kategori jika ditemukan
    rescue ActiveRecord::RecordNotFound
      raise StandardError.new("Kategori dengan ID #{id} tidak ditemukan.")
    end
  end
end
