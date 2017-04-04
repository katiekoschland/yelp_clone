require 'rails_helper'

feature 'restaurants' do
  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context "restaurants have been added" do
    before do
      Restaurant.create(name: 'La Poule au Pot')
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('La Poule au Pot')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context "creating restaurants" do
    scenario "prompts user to fill out a form, then displays the new restaurant" do
      visit '/restaurants'
      click_link "Add a restaurant"
      fill_in 'Name', with: "Pizza Express"
      click_button "Create Restaurant"
      expect(page).to have_content "Pizza Express"
      expect(current_path).to eq '/restaurants'
    end
  end

  context 'an invalid restaurant' do
    scenario 'does not let you submit a name that is too short' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'kf'
      click_button 'Create Restaurant'
      expect(page).not_to have_css 'h2', text: 'kf'
      expect(page).to have_content 'error'
    end
  end

  context "viewing restaurants" do
    let!(:pret){ Restaurant.create(name: 'Pret') }

    scenario 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link 'Pret'
      expect(page).to have_content 'Pret'
      expect(current_path).to eq "/restaurants/#{pret.id}"
    end
  end

  context 'editing restaurants' do
    before { Restaurant.create name: 'Homeslice', description: 'Best aubergine, cauliflower cheese and spinach pizza', id:1 }
    scenario 'let a user edit a restaurant' do
      visit '/restaurants'
      click_link 'Edit Homeslice'
      fill_in 'Name', with: 'Homeslice'
      fill_in 'Description', with: 'Best aubergine, cauliflower cheese and spinach pizza'
      click_button 'Update Restaurant'
      click_link 'Homeslice'
      expect(page).to have_content 'Homeslice'
      expect(page).to have_content 'Best aubergine, cauliflower cheese and spinach pizza'
      expect(current_path).to eq '/restaurants/1'
    end
  end

  context 'deleting restaurants' do

    before{ Restaurant.create name: 'Itsu', description: 'Delicious salmon teriyaki' }

    scenario 'removes a restaurant when a user clicks a delete link' do
      visit '/restaurants'
      click_link 'Delete Itsu'
      expect(page).not_to have_content 'Itsu'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

  end

end
