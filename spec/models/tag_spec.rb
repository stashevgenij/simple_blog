require 'rails_helper'

RSpec.describe Tag, type: :model do
  let(:tag) { create :tag }

  context '(validations)' do
    subject { tag }

    it { is_expected.to validate_presence_of(:tag_name) }
    it { is_expected.to validate_uniqueness_of(:tag_name).case_insensitive }
  end
end
