require 'rails_helper'

RSpec.describe Wiki, type: :model do
  let(:title) { Faker::Hipster.sentence(3, true, 2) }
  let(:body) { Faker::Lorem.paragraph(2, true, 4) }

  let(:user) { create(:user) }
  let(:wiki) { create(:wiki) }

  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_presence_of(:user) }

  it { is_expected.to validate_length_of(:title).is_at_least(5) }
  it { is_expected.to validate_length_of(:body).is_at_least(20) }

  describe 'attributes' do
    it 'has title and body' do
      expect(wiki).to have_attributes(title: wiki.title, body: wiki.body)
    end
  end
end
