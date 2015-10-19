class AddQuantityToQuotes < ActiveRecord::Migration
  def change
    add_column :quotes, :quantity, :integer
  end
end
