require 'rails_helper'

RSpec.describe 'wikis/show.html.erb', type: :view do
  before(:each) do
    # expect(view).to receive(:policy).and_return(double("some policy", new?: true))
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
    expect(rendered).to match(/MyTexttttttttttttttt/)
    expect(rendered).to match(//)
  end
end
