

feature "Devise actions" do
  scenario "Visitor registers successfully via register form" do
    visit new_user_registration_path
    within '#login-form' do
      fill_in 'email', with: Faker::Internet.email
      fill_in 'password-confirmation', with: '123qwertyuip1'
      fill_in 'password', with: '123qwertyuip1'
      click_button('submit-login')
    end
    expect(page).not_to have_content 'Sign Up'
    expect(page).not_to have_content 'Sign In'
    expect(page).to have_content 'Sign Out'
    expect(page).to have_content 'SIMPLE TODO LISTS'
    expect(page).to have_content 'Add TODO List'
  end

  scenario "Visitor log in successfully via log in form" do
    user = User.create!(email: Faker::Internet.email, 
      password_confirmation:'123qwertyuip1', password: '123qwertyuip1')
    visit new_user_session_path
    within '#login-form' do
      fill_in 'email', with: user.email
      fill_in 'password', with: '123qwertyuip1'
      click_button('submit-login')
    end
    expect(page).not_to have_content 'Sign In'
    expect(page).to have_content 'Sign Out'
    expect(page).to have_content 'Sign Out'
    expect(page).to have_content 'SIMPLE TODO LISTS'
    expect(page).to have_content 'Add TODO List'
  end  

  scenario "Visitor log out successfully" do
    login_as(FactoryGirl.create(:user))
    visit root_path
    click_link 'Sign Out'
    expect(page).not_to have_content 'Sign Out'
    expect(page).to have_content 'Sign Up'
    expect(page).to have_content 'Sign in with facebook'
    expect(current_path).to match(new_user_session_path)
  end  
end

