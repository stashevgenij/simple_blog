require 'rails_helper.rb'

feature 'Listing posts' do  
  let(:published_posts) { create_list :published_posts, 6 }
  let(:unpublished_posts) { create_list :unpublished_posts, 6 }

  scenario 'user views 1st page' do
    visit posts_path

    expect(page).to have_text('Published Post', count: 5)
    expect(page).to have_text('Unpublished Post', count: 5)
  end

  scenario 'user views 2nd page' do
    visit articles_path

    click_on '❯'

    expect(page).to have_text('Published Post', count: 1)
  end
end