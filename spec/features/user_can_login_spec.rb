require "rails_helper"

RSpec.feature "user can login" do
  scenario "user sees dashboard" do
    User.create(name: "jones", username: "jones", password: "password")

    visit root_path

    expect(page).not_to have_content "Logout"

    click_on "Login"
    fill_in "Username", with: "jones"
    fill_in "Password", with: "password"
    click_button "Login"

    expect(page).to have_content "Welcome jones"
    expect(current_path).to eq dashboard_path

    expect(page).not_to have_content "Login"
    expect(page).not_to have_content "Create Account"

    click_on "Logout"

    expect(page).not_to have_content "Welcome jones"
    expect(page).to have_content "Login"
    expect(page).to have_content "Create Account"
  end

  scenario "user sees error message" do
    User.create(name: "jones", username: "jones", password: "password")

    visit root_path

    click_on "Login"
    fill_in "Password", with: "password"
    click_button "Login"
    expect(page).to have_content "Invalid login"

    fill_in "Username", with: "jones"
    click_button "Login"
    expect(page).to have_content "Invalid login"
  end
end
