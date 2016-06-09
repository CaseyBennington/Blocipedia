require 'rails_helper'

RSpec.describe 'wikis/edit.html.erb', type: :view do
  before(:each) do
    @wiki = assign(:wiki, Wiki.create!(
                            title: 'Title',
                            body: 'MyTexttttttttttttttt',
                            private: false,
                            user: create(:user)
    ))
  end

  it 'renders new wiki form' do
    render
    assert_select 'form[action=?][method=?]', wiki_path(@wiki), 'post' do
      assert_select 'input#wiki_title[name=?]', 'wiki[title]'
      assert_select 'textarea#wiki_body[name=?]', 'wiki[body]'
    end
  end
end
