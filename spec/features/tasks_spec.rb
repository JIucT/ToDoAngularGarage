feature "Tasks actions" do
  let(:user) { FactoryGirl.create(:user) }

  background do 
    login_as(user)
  end

  before(:each) do
    visit root_path
  end

  scenario "User mark task as completed", js: true do
    first('.panel-body .task-name').set("Task to mark completed")
    first('.new-task-btn').click
    first('.task-completion input').set(true)
    expect(page.first('.tasks-table tr b')['style']).to match('text-decoration: line-through')
  end

  scenario "User changes task name", js: true do
    first('.panel-body .task-name').set("Task to mark completed")
    first('.new-task-btn').click
    page.execute_script("$('.tasks-table tr td a span').first().click()")
    page.first('form .editable-has-buttons').set("Edited task name")
    page.first('form .editable-buttons .btn-primary').click
    expect(page.first('.tasks-table tr').text).to match('Edited task name')
  end

  scenario "User deletes task", js: true do
    first('.panel-body .task-name').set("Task to delete")
    first('.new-task-btn').click
    page.execute_script("$('.tasks-table .remove-task').first().click()")
    page.driver.browser.switch_to.alert.accept
    expect(page).not_to have_content('Task to delete')
  end

  # scenario "User changes task priority", js: true do
  #   sleep(10)
  #   project = user.projects.order("created_at DESC").first
  #   task = project.tasks.order("priority DESC")[-2]
  #   drop_task = project.tasks.order("priority DESC")[1]
  #   task_elem = page.first('.tasks-table').all('tr').at(project.tasks.size - 2)
  #   drop_task_elem = page.first('.tasks-table').all('tr').at(1)

  #   task_elem.drag_to(drop_task_elem)
  #   drop_task_elem.click
  #   sleep(10)
  #   p page.first('.tasks-table').all('tr').at(-2).text
  #   p page.first('.tasks-table').all('tr').at(-3).text
  #   expect(page.first('.tasks-table').all('tr').at(1).text).to match(task.title)
  #   expect(page.first('.tasks-table').all('tr').at(2).text).to match(drop_task.title)

  #   # expect(page).to have_content 'Task name 0'
  #   # expect(page).to have_content 'Task name 2'
  #   # expect(page).to have_content 'Task name 3'
  #   # expect(page).to have_content 'Task name 5'
  #   # expect(page).to have_content 'Task name 7'
  #   # expect(page).to have_content 'Enter project name'
  #   # expect(page).to have_content 'Edited project name'
  # end
end