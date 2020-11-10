class AddIndexOnCreatedAtToPostsAndComments < ActiveRecord::Migration[6.0]
  def change
    add_index :posts,    :created_at
    add_index :comments, :created_at
  end
end
