require 'rails_helper'

feature 'Deleting post', js: false do
  let(:user)    { create :user }
  let(:post)    { create :post, user: user }

  scenario 'user deletes post' do
    sign_in user

    visit post_path(post)    

    expect { click_on 'Delete Post' }.to change(Post, :count).by(-1)
  end

end