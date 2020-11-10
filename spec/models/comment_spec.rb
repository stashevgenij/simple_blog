require 'rails_helper'

RSpec.describe Comment, type: :model do

  let(:user) { create :user }
  let(:post) { create :post, user: user }

  context "validations tests" do
    it "ensures the author is present" do
      comment = post.comments.new(text: "Test comment.")
      expect(comment.valid?).to eq(false)
    end

    it "ensures the post is present" do
      comment = user.comments.new(text: "Test comment.")
      expect(comment.valid?).to eq(false)
    end

    it "ensures the text is present" do
      comment = user.comments.new(post: post)
      expect(comment.valid?).to eq(false)
    end

    it "doesn't create very long comment" do
      comment = user.comments.new(text: "c" * 601, post: post)
      expect(comment.published?).to eq(true)
    end

    it "should be able to save comment" do
      comment = user.comments.new(text: "Test comment.", post: post)
      expect(comment.save).to eq(true)
    end
  end

  context "scopes tests" do
    let(:params) { { content: "Content to test comment.", title: "Test Post" } }
    before(:each) do
      user.comments.create(params)
      user.comments.create(params)
      user.comments.create(params)
      user.comments.create(params.merge(published: false))
      user.comments.create(params.merge(published: false))
    end

    it "returns only published comments" do
      expect(Post.published.count).to eq(3)
    end

    it "orders comments descending created_at" do
      first_comment_later_than_last = Post.ordered.first.created_at > Post.ordered.last.created_at
      first_comment_later_than_second = Post.ordered.first.created_at > Post.ordered.second.created_at
      expect(first_comment_later_than_last && first_comment_later_than_second).to eq(true)
    end
  end

  context "#update_by, #destroy_by" do
    let(:comment) { create :comment, user: user, post: post }

    it "updates comment" do
      comment.update_by({ text: 'Edited comment.' }, user)
      expect(comment.text).to eq("Edited comment.")
    end

    it "destroys comment" do      
      expect { comment.destroy }.to change(Comment, :count).by(-1)
    end

    context "update/delete by user after 15 minutes" do
      before(:each) do
        comment.update_attributes(created_at: 16.minutes.ago)
      end

      it "doesn't update comment after 15 minutes" do
        comment.update_by({ text: 'Edited comment.' }, user)
        expect(comment.errors.last).to eq("can edit in just 15 minutes after creation")
      end

      it "doesn't destroy comment after 15 minutes" do
        comment.destroy_by(user)
        expect(comment.errors.last).to eq("can delete in just 15 minutes after creation")
      end
    end
  end
end
