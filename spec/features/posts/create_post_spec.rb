require 'rails_helper.rb'
require 'support/devise.rb'

feature 'Creating posts' do
  context 'when user logged in' do
    let(:user) { create :user }
    let(:title) { 'Test Post' }
    let(:content) { 'Content to test post.' }

    before(:each) do |check_do_not_publish|
      sign_in user
      visit '/'
      click_link 'New Post'
      fill_in 'Title', with: title
      fill_in 'Content', with: content
      check "Don't publish" unless check_do_not_publish
      click_button 'Create Post'
      expect(page).to have_content(title)
      expect(page).to have_content(content)
    end

    scenario 'can create a post', false do
      expect(page).to have_content("Publication date: ")
      expect(Post.last).to have_attributes(title: title, content: content)
    end

    scenario 'can create unpublished post', true do
      expect(page).to have_content("Creation date: ")
      expect(Post.last).to have_attributes(title: title, content: content)
    end
  end

  context 'when user is a guest' do
    scenario "guest can't create a post" do
      visit '/'
      click_link 'New Post'
      expect(page).to have_content("You need to log in")        
    end
  end
end