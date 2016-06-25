require 'rails_helper'
require 'spec_helper'
require 'pundit/rspec'

describe WikiPolicy do
  subject { WikiPolicy.new(user, wiki) }

  let(:resolved_scope) do
    WikiPolicy::Scope.new(user, Wiki.all).resolve
  end

  context 'being a guest' do
    let(:user) { nil }

    context 'creating a new wiki' do
      let(:wiki) { FactoryGirl.create(:wiki) }

      it { should forbid_new_and_create_actions }
    end

    context 'accessing a wiki' do
      let(:wiki) { FactoryGirl.create(:wiki) }

      it 'includes wiki in resolved scope' do
        expect(resolved_scope).to include(wiki)
      end

      it { should permit_action(:show) }
      it { should permit_edit_and_update_actions }
      it { should forbid_action(:destroy) }
    end
  end

  context 'being an administrator' do
    let(:user) { User.create(role: 'admin') }

    context 'creating a new wiki' do
      let(:wiki) { FactoryGirl.create(:wiki) }

      it { should permit_new_and_create_actions }
    end

    context 'accessing a wiki' do
      let(:wiki) { FactoryGirl.create(:wiki) }

      it 'includes wiki in resolved scope' do
        expect(resolved_scope).to include(wiki)
      end

      it { should permit_action(:show) }
      it { should permit_edit_and_update_actions }
      it { should permit_action(:destroy) }
    end
  end

  context 'being a standard member' do
    let(:user) { FactoryGirl.create(:user) }

    context 'creating a new wiki' do
      let(:wiki) { FactoryGirl.create(:wiki) }

      it { should permit_new_and_create_actions }
    end

    context 'accessing a wiki' do
      let!(:wiki) { FactoryGirl.create(:wiki) }

      it 'includes wiki in resolved scope' do
        expect(resolved_scope).to include(wiki)
      end

      it { should permit_action(:show) }
      it { should permit_edit_and_update_actions }
      it { should forbid_action(:destroy) }
    end
  end
end
