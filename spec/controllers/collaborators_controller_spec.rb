require 'rails_helper'
require 'spec_helper'

RSpec.describe CollaboratorsController, type: :controller do
  let(:user) { create(:user) }
  let!(:wiki) { create(:wiki, user: user) }
  describe 'GET #index' do
    it 'returns http success' do
      get :index, wiki_id: wiki.id
      expect(response).to have_http_status(:success)
    end
  end
end
