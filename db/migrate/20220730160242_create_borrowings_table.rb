class CreateBorrowingsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :borrowings do |t|
      t.belongs_to :book
      t.belongs_to :user
      t.datetime :borrowed_at
      t.datetime :give_back_at
      t.datetime :gave_back_at
      t.timestamps
    end
  end
end
