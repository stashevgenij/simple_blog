require 'rails_helper'
require 'support/devise'

feature 'Creating comments' do
  let(:user) { create :user }
  let(:post) { create :post, user: user }
  let(:commentator) { create :user }

  context 'when user logged in' do
    let(:comment_text) { 'Test comment.' }

    scenario 'can create a comment' do
      sign_in commentator
      visit post_path(post)
      fill_in 'comment_text', with: comment_text
      click_button 'Save Comment'
      expect(page).to have_content(comment_text)
      expect(page).to have_css('.comment-author', text: commentator.email)
      expect(post.comments.last).to have_attributes(text: comment_text)
    end
  end

  context 'when user is a guest' do
    scenario 'cannot create a comment' do
      visit post_path(post)
      expect(page).not_to have_css('textarea#comment_text')
    end
  end
end
