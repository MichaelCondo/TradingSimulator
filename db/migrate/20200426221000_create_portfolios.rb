class CreatePortfolios < ActiveRecord::Migration[6.0]
  def change
    create_table :portfolios do |t|
      t.decimal :portfolio_value
      t.decimal :gain_loss
      t.decimal :investment_value
      t.decimal :book_cost
      t.decimal :cash
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
