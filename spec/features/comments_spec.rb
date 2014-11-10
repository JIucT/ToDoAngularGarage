feature "Comments actions" do
  let(:user) { FactoryGirl.create(:user) }

  background do 
    login_as(user)
  end

  before(:each) do
    visit root_path
  end

  scenario "User adds comment", js: true do
    page.execute_script("$('.task-actions a').last().click()")
    first('.new-comment-text').set("New added comment")
    first('.add-comment form  button[type="submit"]').click
    expect(page).to have_content('New added comment')
  end


  scenario "User deletes comment", js: true do
    page.execute_script("$('.glyphicon-comment').first().click()")
    first('.new-comment-text').set("Comment to delete")
    first('.add-comment form  button[type="submit"]').click
    page.evaluate_script('window.confirm = function() { return true; }')    
    page.execute_script("$('.comment-actions .glyphicon-trash').first().click()")
   #  page.driver.browser.switch_to.alert.accept
    expect(page).not_to have_content('Comment to delete')
  end
end