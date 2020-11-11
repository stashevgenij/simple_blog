require 'rails_helper'

feature 'Editing comment', js: false do
  let(:user)    { create :user }
  let(:villain) { create :user }
  let(:post)    { create :post, user: user }
  let!(:comment) { create :comment, user: user, post: post }

  context 'just created comment' do
    scenario 'user can edit comment' do
      sign_in user

      visit post_path(post)

      expect(page).to have_link('Edit Comment')
    end

    scenario 'user updates comment' do
      sign_in user

      visit post_path(post)
      click_on 'Edit Comment'

      fill_in 'comment_text', with: 'Edited comment.'
      click_on 'Save Comment'

      expect(page).to have_content 'Edited comment.'
      expect(comment.reload).to have_attributes(text: 'Edited comment.', user: user, post: post)
    end

    scenario 'other user cannot edit comment' do
      sign_in villain

      visit post_path(post)

      expect(page).not_to have_link('Edit Comment')
    end
  end

  context 'comment created 16 minutes ago' do
    scenario 'user cannot edit comment' do
      sign_in comment.user

      comment.update(created_at: 16.minutes.ago)

      visit post_path(post)

      expect(page).not_to have_link('Edit Comment')
    end
  end
end
