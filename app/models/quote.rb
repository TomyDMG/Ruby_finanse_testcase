class Quote < ActiveRecord::Base
  belongs_to :user
  validates :user_id, :quantity, presence: true
  validates :symbol, presence: true, uniqueness: { case_sensitive: false }
  validates :quantity, :numericality => { greater_than: 0, less_than: 999999999 }

  def total_price
    self.quantity * self.price
  end
end
