class AddPassDigestToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pass_digest, :string
  end
end
