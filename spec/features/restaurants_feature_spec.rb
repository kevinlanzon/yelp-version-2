require 'rails_helper'

describe 'restaurant' do
  context 'new restaurant' do
    scenario 'viewing restaurants' do
      visit '/restaurants'
      expect(page).to have_content 'No Restaurants Yet'
    end
  end

  context 'adding an invalid restaurant' do
    it 'does not let you submit a name that is too short' do
      sign_in_helper
      visit '/restaurants'
      click_link 'Add Restaurant'
      fill_in 'Name', with: 'kf'
      click_button 'Add'
      expect(page).not_to have_css 'h1', text: 'kf'
      expect(page).to have_content 'error'
    end
  end

  context 'adding a restaurant' do
    scenario 'to the list' do
      sign_in_helper
      visit '/restaurants'
      click_on 'Add Restaurant'
      fill_in 'Name', :with => 'KFC'
      click_on 'Add'
      expect(page).to have_content 'KFC'
    end
  end

  scenario 'does not display "No Restaurants Yet" when restaurant is added' do
    sign_in_helper
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
    before {sign_in_helper}
    before {create_restaurant('KFC')}

    scenario 'cannot be done if a user is not signed in' do
      visit "/restaurants"
      click_link 'Sign out'
      click_link 'Delete KFC'
      expect(page).to have_content "You need to sign in or sign up before continuing."
    end

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

    scenario 'users can only delete restaurants which they have created' do
      visit('/')
      click_link 'Sign out'
      second_login
      click_link 'Delete KFC'
      expect(page).to have_content 'Only the creator of the restaurant can delete it'
    end
  end

  context 'editing a restaurant' do
    before {sign_in_helper}
    before {create_restaurant('KFC')}

    scenario 'let a user edit the restaurant name' do
      visit '/restaurants'
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      click_on 'Update'
      expect(current_path).to eq '/restaurants'
      expect(page).to have_content 'Restaurant updated'
    end

    scenario 'users can only edit restaurants which they have created' do
      visit('/')
      click_link 'Sign out'
      second_login
      click_link 'Edit KFC'
      expect(page).to have_content 'Only the creator of the restaurant can edit it'
    end
  end

  def sign_in_helper
    visit('/')
    click_link 'Sign up'
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: 'testtest'
    fill_in 'Password confirmation', with: 'testtest'
    click_button 'Sign up'
  end

  def create_restaurant(restaurant_name)
    visit '/restaurants'
    click_link 'Add Restaurant'
    fill_in 'Name', with: restaurant_name
    click_button 'Add'
  end

  def second_login
    visit '/restaurants'
    click_link 'Sign up'
    fill_in 'Email', with: "test2@test.com"
    fill_in 'Password', with: "testtest"
    fill_in 'Password confirmation', with: "testtest"
    click_button 'Sign up'
  end

