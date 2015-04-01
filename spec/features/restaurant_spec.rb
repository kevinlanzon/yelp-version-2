require 'rails_helper'

describe 'restaurant' do
  context 'new restaurant' do
    scenario 'viewing restaurants' do
      visit '/restaurants'
      expect(page).to have_content 'No Restaurants Yet'
    end
  end

  context 'adding a restaurant' do
    scenario 'to the list' do
      visit '/restaurants'
      click_on 'Add Restaurant'
      fill_in 'Name', :with => 'KFC'
      click_on 'Add'
      expect(page).to have_content 'KFC'
    end
  end

  scenario 'does not display "No Restaurants Yet" when restaurant is added' do
    visit '/restaurants'
     click_on 'Add Restaurant'
      fill_in 'Name', :with => 'KFC'
      click_on 'Add'
      expect(page).not_to have_content 'No Restaurants Yet'
    end
  end

  context 'viewing a restaurant' do

    let!(:kfc){Restaurant.create(name:'KFC')}

    scenario 'lets the user view a restaurant' do
      visit '/restaurants'
      click_on 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end

    scenario 'let the user get back to the index page' do
      visit '/restaurants'
      click_on 'KFC'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
      click_on 'Home'
      expect(current_path).to eq "/restaurants"
    end
  end

  context 'deleting a restaurant' do

    let!(:kfc){Restaurant.create(name:'KFC')}

    scenario 'let the user delete a restaurant' do
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted'
    end

    scenario 'will destroy the restaurant and delete reviews' do
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in "Thoughts", with: "this isn't chicken!"
      click_button 'Leave Review'
      click_link 'Delete KFC'
      expect(page).not_to have_content "this isn't chicken!"
    end
  end

  context 'editing a restaurant' do

     let!(:kfc){Restaurant.create(name:'KFC')}

     scenario 'let a user edit the restaurant name' do
      visit '/restaurants'
      click_link 'Edit KFC'
      fill_in 'Name', :with => 'Kentucky Fried Chicken'
      click_on 'Update'
      expect(current_path).to eq '/restaurants'
      expect(page).to have_content 'Restaurant updated'
    end
  end