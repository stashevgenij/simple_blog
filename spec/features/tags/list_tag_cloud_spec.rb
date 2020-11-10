require 'rails_helper'

feature 'Listing tag cloud', js: false do
  let!(:tags) { create_list :tag, 3 }

  scenario 'user sees tag cloud' do
    visit root_path

    expect(page).to have_css(".tag-cloud .tag-cloud-item", count: 3)
  end
end