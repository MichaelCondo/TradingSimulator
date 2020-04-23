class CreatePortfolios < ActiveRecord::Migration[6.0]
  def change
    create_table :portfolios do |t|
      t.integer :user_id
      t.decimal :portfolio_value
      t.decimal :gain_loss
      t.decimal :investment_value
      t.decimal :book_cost
      t.decimal :cash

      t.timestamps
    end
  end
end
