require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create :user }

  context '(validations)' do
    it 'ensures the user is present' do
      post = Post.new(content: 'Content to test post.', title: 'Test Post')
      expect(post.valid?).to eq(false)
    end
    it 'ensures the title is present' do
      post = user.posts.new(content: 'Content to test post.')
      expect(post.valid?).to eq(false)
    end

    it 'ensures the content is present' do
      post = user.posts.new(title: 'Test Post')
      expect(post.valid?).to eq(false)
    end

    it 'ensures the post is published by default' do
      post = user.posts.new(content: 'Content to test post.', title: 'Test Post')
      expect(post.published?).to eq(true)
    end

    it 'should be able to save post' do
      post = user.posts.new(content: 'Content to test post.', title: 'Test Post')
      expect(post.save).to eq(true)
    end
  end

  context '(scopes)' do
    let(:params) { { content: 'Content to test post.', title: 'Test Post' } }
    before(:each) do
      user.posts.create(params)
      user.posts.create(params)
      user.posts.create(params)
      user.posts.create(params.merge(published: false))
      user.posts.create(params.merge(published: false))
    end

    it 'returns only published posts' do
      expect(Post.published.count).to eq(3)
    end

    it 'orders posts descending created_at' do
      first_post_later_than_last = Post.ordered.first.created_at > Post.ordered.last.created_at
      first_post_later_than_second = Post.ordered.first.created_at > Post.ordered.second.created_at
      expect(first_post_later_than_last && first_post_later_than_second).to eq(true)
    end
  end

  describe '#tags_string=' do
    it 'deserializes tags from a comma-separated string' do
      post = build :post, tags_string: 'abc, xyz'

      expect(post.tags.map(&:tag_name)).to eq %w[abc xyz]
    end
  end

  describe '#tags_string' do
    it 'serializes tags to a comma-separated string' do
      tag_abc = build :tag, tag_name: 'abc'
      tag_xyz = build :tag, tag_name: 'xyz'

      post = build :post, tags: [tag_abc, tag_xyz]

      expect(post.tags_string).to eq 'abc, xyz'
    end
  end
end
