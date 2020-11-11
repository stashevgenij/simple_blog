require 'rails_helper'

feature 'Editing post', js: false do
  let(:user) { create :user }
  let(:post) { create :post, user: user }

  scenario 'user updates post' do
    sign_in post.user

    visit edit_post_path(post)

    yesterday_date = 1.day.ago

    fill_in 'Title', with: 'Edited Title'
    fill_in 'Content', with: 'Edited content.'
    select_date_and_time yesterday_date, from: 'post_created_at'
    click_on 'Save Post'

    expect(page).to have_content 'Edited Title'
    expect(page).to have_content 'Edited content.'
    expect(page).to have_content yesterday_date.strftime('%F')
    expect(post.reload).to have_attributes(title: 'Edited Title', content: 'Edited content.')
    expect(post.reload.created_at).to be_within(1.minute).of yesterday_date
  end
end
