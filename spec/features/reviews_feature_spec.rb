require 'rails_helper'

feature 'reviewing' do
  before do
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    click_button('Sign up')
    Restaurant.create name: 'KFC'
  end

  scenario 'allow users to fill in a review using a form' do
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in "Thoughts", with: "this isn't chicken!"
    select '3', from: 'Rating'
    click_button 'Leave Review'
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content("this isn't chicken!")
  end

  scenario 'users can only leave one review per restaurant' do
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in "Thoughts", with: "this isn't chicken!"
    select '3', from: 'Rating'
    click_button 'Leave Review'
    expect(current_path).to eq '/restaurants'
    click_link 'Review KFC'
    expect(page).to have_content("You have already reviewed this restaurant")
  end
end