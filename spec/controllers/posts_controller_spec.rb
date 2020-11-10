require 'rails_helper'

describe PostsController do
  let(:user) { create :user }
  let(:blog_post) { create :post, user: user }

  context 'when not signed in' do

    it 'cannot view unpublished post' do
      user = create :user
      blog_post = create :post, :unpublished, user: user

      expect do
        get :show, params: {id: blog_post.id}
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'cannot open new post page' do
      get :new

      expect(response).to redirect_to(new_user_session_url)
    end

    it 'cannot create post' do
      post :create

      expect(response).to redirect_to(new_user_session_url)
    end

    it 'cannot edit post' do
      get :edit, params: {id: blog_post}

      expect(response).to redirect_to(new_user_session_url)
    end

    it 'cannot update post' do
      put :update, params: {id: blog_post}

      expect(response).to redirect_to(new_user_session_url)
    end

    it 'cannot delete post' do
      delete :destroy, params: {id: blog_post}

      expect(response).to redirect_to(new_user_session_url)
    end
  end

  context 'when signed in' do
    let(:user)    { create :user }
    let(:villain) { create :user }

    before do
      sign_in user
    end

    describe 'creates post' do
      context '(valid data)' do
        it 'creates new post' do
          valid_data = attributes_for :post, title: 'Test Post', content: 'Content to test post.'

          expect do
            post :create, params: { post: valid_data }
          end.to change(Post, :count).by(1)
        end
      end

      context '(invalid data)' do
        it 'does not create new post' do
          invalid_data = attributes_for :post, title: '', content: ''

          expect do
            post :create, params: { post: invalid_data }
          end.not_to change(Post, :count)
        end
      end
    end

    describe 'updates post' do
      context '(valid data)' do
        let(:yesterday) { '2020-11-09' }
        let(:valid_post) do
          attributes_for :post, title: 'Edited Title',
                                content: 'Edited content.',
                                created_at: yesterday

        end

        it 'redirects to post' do
          put :update, params: {id: blog_post, post: valid_post}

          expect(response).to redirect_to(blog_post)
        end

        it 'updates post' do
          put :update, params: {id: blog_post, post: valid_post}

          expect(blog_post.reload.title).to eq('Edited Title')
          expect(blog_post.reload.content).to eq('Edited content.')
          expect(blog_post.reload.created_at).to eq(yesterday)
        end

        context 'not owned post' do
          it 'raises 404 error' do
            sign_in villain

            expect do
              put :update, params: {id: blog_post, post: valid_post}
            end.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end

      context '(invalid data)' do
        it 'does not update post' do
          invalid_post = attributes_for :post, title: '', content: ''

          put :update, params: {id: blog_post, post: invalid_post}

          expect(blog_post.reload.title).not_to eq('')
        end
      end
    end

    describe 'deletes post' do
      it 'redirects to posts' do
        delete :destroy, params: {id: blog_post}

        expect(response).to redirect_to(posts_path)
      end

      it 'deletes post' do
        delete :destroy, params: {id: blog_post}

        expect(Post.exists?(blog_post.id)).to be_falsy
      end
    end
  end
end