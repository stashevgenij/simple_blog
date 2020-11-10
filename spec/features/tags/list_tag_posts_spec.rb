require 'rails_helper'

feature 'List all tags', js: false do
  let!(:tag)       { create :tag }
  let!(:other_tag) { create :tag }

  before(:each) do
    visit root_path
    click_on tag.tag_name
  end

  scenario 'user can get to tag page with posts' do
    expect(page).to have_css("h1", text: "Posts with tag #{tag.tag_name}")
  end

  scenario 'user sees posts only with clicked tag' do
    expect(page).to have_content("Test Post", count: 2)
  end
end