class AddColumnsSymbolPriceToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :symbol, :string
    add_column :quotes, :price, :decimal
  end
end
