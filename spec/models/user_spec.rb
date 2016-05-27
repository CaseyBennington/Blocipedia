require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  it { is_expected.to have_many(:wikis) }

  # Shoulda tests for email
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to allow_value('user@bloccit.com').for(:email) }

  # Shoulda tests for password
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_length_of(:password).is_at_least(6) }

  describe 'attributes' do
    it 'should have an email attribute' do
      expect(user).to have_attributes(email: user.email)
    end

    it 'responds to role' do
      expect(user).to respond_to(:role)
    end

    it 'responds to admin?' do
      expect(user).to respond_to(:admin?)
    end

    it 'responds to standard?' do
      expect(user).to respond_to(:standard?)
    end

    it 'responds to premium?' do
      expect(user).to respond_to(:premium?)
    end
  end

  describe 'roles' do
    it 'is standard by default' do
      expect(user.role).to eq('standard')
    end

    context 'standard user' do
      it 'returns true for #standard?' do
        expect(user.standard?).to be_truthy
      end

      it 'returns false for #admin?' do
        expect(user.admin?).to be_falsey
      end
    end

    context 'admin user' do
      before do
        user.admin!
      end

      it 'returns false for #standard?' do
        expect(user.standard?).to be_falsey
      end

      it 'returns true for #admin?' do
        expect(user.admin?).to be_truthy
      end
    end
  end

  describe 'invalid user' do
    let(:user_with_invalid_email) { build(:user, email: '') }

    it 'should be an invalid user due to blank email' do
      expect(user_with_invalid_email).to_not be_valid
    end
  end

  describe '.avatar_url' do
    let(:known_user) { create(:user, email: 'blochead@bloc.io') }

    it 'returns the proper Gravatar url for a known email entity' do
      expected_gravatar = 'http://gravatar.com/avatar/bb6d1172212c180cfbdb7039129d7b03.png?s=48'
      expect(known_user.avatar_url(48)).to eq(expected_gravatar)
    end
  end
end
