require 'rails_helper.rb'
require './spec/support/helpers/have_tags_matcher.rb'

feature 'Adding tags to post' do

  let(:user) { create :user }
  let(:post) { build  :post, user: user }
  let(:tags) { ["tag1", "tag2", "tag3"] }

  before(:each) do
    sign_in user
  end

  scenario 'can create a post with tags' do
    visit new_post_path

    fill_in 'Title',   with: post.title
    fill_in 'Content', with: post.content
    fill_in 'Tags',    with: tags.join(", ")
    click_button 'Create Post'

    expect(Post.last.tags.map(&:tag_name)).to eq(tags)
    expect(page).to have_content(tags[0])
    expect(page).to have_content(tags[1])
    expect(page).to have_content(tags[2])
    # Custom matcher from support/helpers/have_tags_matcher.rb
    # expect(page).to have_tags(tags)
  end

  scenario 'can add tags to the post' do
    post.save

    visit edit_post_path(post)    
    fill_in 'Tags', with: tags.join(", ")
    click_button 'Update Post'

    # Custom matcher from support/helpers/have_tags_matcher.rb
    expect(page).to have_tags(tags)
  end
end