require 'rails_helper'

feature 'List post comments', js: false do
  let(:user)      { create :user }
  let(:post)      { create :post, user: user }
  let!(:comments) { create_list :comment, 5, user: user, post: post}

  scenario 'user sees 5 comments' do
    visit post_path(post)

    expect(page).to have_content("Test comment.", count: 5)
  end
end