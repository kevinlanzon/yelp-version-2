require 'rails_helper'

context 'creating restaurants' do

  context 'an invalid restaurant' do
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
end