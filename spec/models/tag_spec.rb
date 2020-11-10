require 'rails_helper'

RSpec.describe Tag, type: :model do

  context '(validations)' do
    it "ensures the tag name is present" do
      tag = Tag.new(attributes_for :tag, tag_name: "")
      expect(tag.valid?).to eq(false)
    end

    it "ensures the tag name is present" do
      tag        = Tag.new(attributes_for :tag, tag_name: "tag1")
      second_tag = Tag.new(attributes_for :tag, tag_name: "tag1")
      third_tag  = Tag.new(attributes_for :tag, tag_name: "TAG1")
      tag.save
      expect(second_tag.valid?).to eq(false)   
      expect(third_tag.valid?).to  eq(false)      
    end

    it "should be able to save tag" do
      tag = build :tag
      expect(tag.save).to eq(true)
    end
  end
end
