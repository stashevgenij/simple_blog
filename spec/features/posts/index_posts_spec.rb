require 'rails_helper.rb'

feature 'Listing posts' do  
  let(:user)               { create :user }
  let!(:published_posts)   { create_list :post, 6, user: user }
  let!(:unpublished_posts) { create_list :post, 6, :unpublished, user: user }

  scenario 'user views 1st page' do
    visit posts_path

    expect(page).to have_text('Test Post', count: 5)
  end

  scenario 'user views 2nd page' do
    visit posts_path

    click_on 'Next →'

    expect(page).to have_text('Test Post', count: 1)
  end

  scenario 'user views 1st page' do
    visit posts_path

    expect(page).not_to have_text('Test Unpublished Post')
  end

  scenario 'user sees info about the author' do
    visit posts_path

    expect(page).to have_text(user.email, count: 5)
    expect(page).to have_text(user.created_at.strftime("%F"), count: 5)
  end
end