require 'rails_helper'

RSpec.describe 'wikis/index.html.erb', type: :view do
  before(:each) do
    assign(:wikis, [
             Wiki.create!(
               title: 'Title',
               body: 'MyTexttttttttttttttt',
               private: false,
               user: create(:user)
             ),
             Wiki.create!(
               title: 'Title',
               body: 'MyTexttttttttttttttt',
               private: false,
               user: create(:user)
             )
           ])
  end

  it 'renders a list of wikis' do
    render
  end
end
