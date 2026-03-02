require 'rails_helper'

RSpec.describe Note, type: :model do
  it { is_expected.to validate_presence_of(:title) }

  it "is valid without content" do
    note = build(:note, content: nil)
    expect(note).to be_valid
  end

  it { is_expected.to have_db_column(:title).of_type(:string) }
  it { is_expected.to have_db_column(:content).of_type(:text) }
end
