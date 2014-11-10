
feature "Projects actions" do
  let(:user) do 
    User.create!(email: Faker::Internet.email, 
      password_confirmation:'123qwertyuip1', password: '123qwertyuip1')
  end

  background do 
    login_as(user)
  end

  before(:each) do
    visit root_path
  end

  scenario "User adds a project and several tasks", js: true do
    click_button('Add TODO List')
    click_button('Add TODO List')
    for i in 0..2 do
      first('.panel-body .task-name').set("Task name #{i}")
      first('.new-task-btn').click
    end

    for i in 3..7 do
      page.all('.panel-body .task-name').last.set("Task name #{i}")
      page.all('.new-task-btn').last.click
    end
    page.execute_script("$('.edit-project-title span').last().click()")
    page.all('form .editable-has-buttons').last.set("Edited project name")
    page.all('form .editable-buttons .btn-primary').last.click

    expect(page).to have_content 'Task name 0'
    expect(page).to have_content 'Task name 2'
    expect(page).to have_content 'Task name 3'
    expect(page).to have_content 'Task name 5'
    expect(page).to have_content 'Task name 7'
    expect(page).to have_content 'Enter project name'
    expect(page).to have_content 'Edited project name'
  end
end

