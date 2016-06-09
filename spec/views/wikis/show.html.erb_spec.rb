require 'rails_helper'

RSpec.describe 'wikis/show.html.erb', type: :view do
  before(:each) do
    @wiki = assign(:wiki, Wiki.create!(
                            title: 'Title',
                            body: 'MyTexttttttttttttttt',
                            private: false,
                            user: create(:user)
    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end
