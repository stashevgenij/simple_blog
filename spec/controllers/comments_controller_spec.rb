require 'rails_helper'

describe CommentsController do
  let(:user)      { create :user }
  let(:blog_post) { create :post, user: user }
  let(:comment)   { create :comment, user: user, post: blog_post }
  let(:comment_text) { 'Test comment.' }

  context 'when not signed in' do
    it 'cannot create comment' do
      post :create, params: { post_id: blog_post }

      expect(response).to redirect_to(new_user_session_url)
    end

    it 'cannot update comment' do
      put :update, params: { post_id: blog_post, id: comment }

      expect(response).to redirect_to(new_user_session_url)
    end

    it 'cannot delete comment' do
      delete :destroy, params: { id: blog_post }

      expect(response).to redirect_to(new_user_session_url)
    end
  end

  context 'when signed in' do
    let(:villain) { create :user }

    before do
      sign_in user
    end

    describe 'creates comment' do
      context '(valid data)' do
        it 'creates new comment' do
          valid_data = attributes_for :comment, user: user, post: blog_post

          expect do
            post :create, params: { post_id: blog_post, comment: valid_data }
          end.to change(Comment, :count).by(1)
        end
      end

      context '(invalid data)' do
        it 'does not create new comment' do
          invalid_data = attributes_for :comment, text: '', user: user, post: blog_post

          expect do
            post :create, params: { post_id: blog_post, comment: invalid_data }
          end.not_to change(Comment, :count)
        end
      end
    end

    describe 'updates comment' do
      context '(valid data)' do
        let(:valid_comment) do
          attributes_for :comment, text: 'Edited comment.', user: user, post: blog_post
        end

        it 'redirects to post' do
          put :update, params: { id: comment, comment: valid_comment, post_id: blog_post }

          expect(response).to redirect_to(blog_post)
        end

        it 'updates comment' do
          put :update, params: { id: comment, comment: valid_comment, post_id: blog_post }

          expect(comment.reload.text).to eq('Edited comment.')
        end

        context 'not owned comment' do
          it 'raises 404 error' do
            sign_in villain

            expect do
              put :update, params: { id: comment, comment: valid_comment, post_id: blog_post }
            end.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end

      context '(invalid data)' do
        it 'does not update comment' do
          invalid_comment = attributes_for :comment, text: '', user: user, post: blog_post

          put :update, params: { id: comment, comment: invalid_comment, post_id: blog_post }

          expect(comment.reload.text).not_to eq('')
        end
      end
    end

    it 'deletes comment' do
      delete :destroy, params: { id: comment }

      expect(response).to redirect_to(blog_post)
      expect(Comment.exists?(comment.id)).to be_falsy
    end
  end
end
