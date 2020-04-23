class CreatePortfolioStocks < ActiveRecord::Migration[6.0]
  def change
    create_table :portfolio_stocks do |t|
      t.integer :portfolio_id
      t.string :ticker
      t.string :name
      t.decimal :current_price
      t.string :stock_exchange
      t.decimal :dividend_yield
      t.decimal :dividend_per_share
      t.integer :quantity
      t.decimal :book_cost
      t.decimal :market_value
      t.decimal :gain_loss

      t.timestamps
    end
  end
end
