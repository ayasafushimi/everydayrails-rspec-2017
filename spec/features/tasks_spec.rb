require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  # ユーザーがタスクの状態を切り替える
  scenario "user toggles a task", js: true do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project,
                                name: "RSpec tutorial",
                                owner: user)
    task = project.tasks.create!(name: "Finish RSpec tutorial")

    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    # click_link_or_button "RSpec tutorial"
    using_wait_time(5) do
      click_link "RSpec tutorial"
    end

    check "Finish RSpec tutorial"
    save_and_open_page
    expect(page).to have_css "label#task_#{task.id}.completed"
    expect(task.reload).to be_completed

    uncheck "Finish RSpec tutorial"

    expect(page).to_not have_css "label#task_#{task.id}.completed"
    expect(page).to_not be_completed

  end
end
