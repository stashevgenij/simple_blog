require 'rails_helper'

feature 'Creating posts' do
  context 'when user logged in' do
    let(:user) { create :user }
    let(:title) { 'Test Post' }
    let(:content) { 'Content to test post.' }

    before(:each) do |scenario|
      sign_in user
      visit '/'
      click_link 'New Post'
      fill_in 'Title', with: title
      fill_in 'Content', with: content
      check 'Do not publish' if scenario.description == 'can create unpublished post'
      click_button 'Save Post'
      expect(page).to have_content(title)
      expect(page).to have_content(content)
      expect(Post.last).to have_attributes(title: title, content: content)
    end

    scenario 'can create a post' do
      expect(page).not_to have_content('(unpublished)')
    end

    scenario 'can create unpublished post' do
      expect(page).to have_content('(unpublished)')
    end
  end

  context 'when user is a guest' do
    scenario "guest can't create a post" do
      visit '/'
      click_link 'New Post'
      expect(page).to have_content('You need to log in')
    end
  end
end
