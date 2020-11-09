require 'rails_helper'

feature 'Editing post', js: false do
  let(:post) { create :post }

  scenario 'user updates post' do
    sign_in post.user

    visit edit_post_path(post)

    today_date = Time.now.strftime("%F")

    fill_in 'Title', with: 'Edited Title'
    fill_in 'Content', with: 'Edited content.'
    fill_in 'Created at', with: today_date
    click_on 'Save'

    expect(page).to have_content 'Edited Title'
    expect(page).to have_content 'Edited content.'
    expect(page).to have_content today_date
    expect(post.reload).to have_attributes(title: 'Edited Title', content: 'Edited content.', created_at: today_date)
  end
end