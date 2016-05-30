require 'rails_helper'
require 'spec_helper'
require 'pundit/rspec'

RSpec.describe ApplicationPolicy do
  let(:user) { FactoryGirl.create(:user) }

  subject { described_class }

  # permissions ".scope" do
  #   pending "add some examples to (or delete) #{__FILE__}"
  # end

  permissions :show? do
    it 'grants access if user is guest' do
      expect(subject).to permit(FactoryGirl.create(:wiki))
    end

    it 'grants access if user is an admin' do
      expect(subject).to permit(User.new(role: 'admin'), FactoryGirl.create(:wiki))
    end

    it 'grants access if user is a standard member' do
      expect(subject).to permit(FactoryGirl.create(:user), FactoryGirl.create(:wiki))
    end
  end

  permissions :create?, :new? do
    it 'grants access if user is guest' do
      expect(subject).to_not permit(FactoryGirl.create(:wiki))
    end

    it 'grants access if user is an admin' do
      expect(subject).to permit(User.new(role: 'admin'), FactoryGirl.create(:wiki))
    end

    it 'grants access if user is a standard member' do
      expect(subject).to permit(FactoryGirl.create(:user), FactoryGirl.create(:wiki))
    end
  end

  permissions :update?, :edit? do
    it 'grants access if user is guest' do
      expect(subject).to permit(FactoryGirl.create(:wiki))
    end

    it 'grants access if user is an admin' do
      expect(subject).to permit(User.new(role: 'admin'), FactoryGirl.create(:wiki))
    end

    it 'grants access if user is a standard member' do
      expect(subject).to permit(FactoryGirl.create(:user), FactoryGirl.create(:wiki))
    end
  end

  permissions :destroy? do
    it 'grants access if user is guest' do
      expect(subject).to_not permit(FactoryGirl.create(:wiki))
    end

    it 'grants access if user is an admin' do
      expect(subject).to permit(User.new(role: 'admin'), FactoryGirl.create(:wiki))
    end

    it 'grants access if user is a standard member' do
      expect(subject).to permit(FactoryGirl.create(:user), FactoryGirl.create(:wiki))
    end
  end
end
