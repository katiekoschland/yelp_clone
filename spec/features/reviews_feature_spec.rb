require 'rails_helper'

feature 'reviewing' do
  before { Restaurant.create name: 'Wagamamas' }

  scenario 'allows users to leave a review using a form' do
    visit '/restaurants'
    click_link 'Review Wagamamas'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'

    expect(current_path).to eq '/restaurants'
    click_link 'Wagamamas'
    expect(page).to have_content('so so')
  end
end
