class AddImageColumnToMicroposts < ActiveRecord::Migration[5.2]
  def change
    add_column :microposts, :image, :string
  end
end
