class CreateInvestments < ActiveRecord::Migration[7.0]
  def change
    create_table :investments do |t|
      t.references :user, null: false, foreign_key: true
      t.string :currency
      t.decimal :amount

      t.timestamps
    end
  end
end
