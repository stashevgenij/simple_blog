require 'rails_helper'

feature 'Reading post', js: false do
  let(:user)             { create :user }
  let(:post)             { create :post, user: user }
  let(:unpublished_post) { create :post, :unpublished, user: user }

  context 'guest' do
    scenario 'reads published post' do
      visit post_path(post)

      expect(page).to have_content(post.title)
      expect(page).to have_content(post.content)
    end

    scenario "can't read unpublished post" do
      expect { visit post_path(unpublished_post) }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end

  context 'user' do
    let(:villain) { create :user }

    scenario 'reads his unpublished post' do
      sign_in user
      visit post_path(unpublished_post)

      expect(page).to have_content(unpublished_post.title)
      expect(page).to have_content(unpublished_post.content)
    end

    scenario "can't read someone else's unpublished post" do
      sign_in villain
      expect { visit post_path(unpublished_post) }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end
