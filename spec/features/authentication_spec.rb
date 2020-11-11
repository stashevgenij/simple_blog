require 'rails_helper'

feature 'Signing up', js: false do
  let(:user) { build :user }

  scenario 'register user' do
    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    expect { click_on 'Sign up' }.to change(User, :count).by(1)
  end
end

feature 'Signing in', js: false do
  let(:user) { create :user }

  scenario 'authenticates user with correct data' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    expect(page).to have_css('a', text: 'Logout')
  end
end

feature 'Signing out', js: false do
  let(:user) { create :user }

  scenario 'log out user' do
    sign_in user
    visit '/'
    click_on 'Logout'
    expect(page).to have_css('a', text: 'Login')
  end
end
