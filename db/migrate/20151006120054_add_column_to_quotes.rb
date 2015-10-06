class AddColumnToQuotes < ActiveRecord::Migration
  def change
    add_column :quotes, :symbol, :string
    add_column :quotes, :price, :decimal
    add_column :quotes, :date_trading, :datetime
  end
end
