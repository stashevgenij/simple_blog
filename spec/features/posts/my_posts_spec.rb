require 'rails_helper.rb'

feature 'Listing my posts' do  
  let(:user)              { create :user }
  let(:other_user)        { create :user }
  let!(:published_post)   { create :post, user: user }
  let!(:unpublished_post) { create :post, :unpublished, user: user }

  scenario 'user sees his 2 posts' do
    sign_in user

    visit '/'
    click_on 'My Posts'

    expect(page).to have_text('Test Post')
    expect(page).to have_text('Test Unpublished Post')
  end

  scenario "other user see no posts" do
    sign_in other_user

    visit '/'
    click_on 'My Posts'

    expect(page).not_to have_text('Test Post')
  end
end