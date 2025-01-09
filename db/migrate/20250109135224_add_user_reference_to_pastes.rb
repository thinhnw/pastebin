class AddUserReferenceToPastes < ActiveRecord::Migration[8.0]
  def change
    add_reference :pastes, :user, foreign_key: true
  end
end
