require 'rails_helper.rb'
require 'support/devise.rb'

feature 'Creating comments' do
  let(:user) { create :user }
  let(:post) { create :post, user: user }
  let(:commentator) { create :user }

  context 'when user logged in' do
    let(:comment_text) { 'Test comment.' }

    scenario 'can create a comment' do
      sign_in commentator
      visit post_path(post)
      fill_in 'Text', with: comment_text
      click_button 'Save Comment'
      expect(page).to have_content(comment_text)
      expect(page).to have_content("Author: #{commentator.email}")
      expect(post.comments.last).to have_attributes(text: comment_text)      
    end
  end

  context 'when user is a guest' do
    scenario 'can create a comment' do
      sign_in user
      visit post_path(post)
      puts page.body
      expect(page).not_to have_css("")   
    end
  end
end