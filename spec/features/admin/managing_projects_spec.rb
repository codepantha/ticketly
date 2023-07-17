require 'rails_helper'

RSpec.feature 'Admins can manage projects' do
  let!(:vscode) { FactoryBot.create(:project, name: 'VS Code') }
  let!(:sublime) { FactoryBot.create(:project, name: 'Sublime') }

  before do
    FactoryBot.create(
      :ticket,
      name: 'simple menu fix',
      project: vscode,
      state: FactoryBot.create(:state, name: 'Open')
    )

    FactoryBot.create(
      :ticket,
      name: 'simple menu fix',
      project: vscode,
      state: FactoryBot.create(:state, name: 'Closed')
    )

    login_as(FactoryBot.create(:user, :admin))
    visit admin_root_path
    within(find('ul>li', text: 'Projects')) do
      click_link 'Projects'
    end
  end

  scenario 'and view them with their details' do
    within 'table.projects' do
      expect(page).to have_link 'VS Code'
      expect(page).to have_content '0 new'
      expect(page).to have_content '1 active'
      expect(page).to have_content '1 closed'
    end

    expect(page).to have_current_path(admin_projects_path)
  end

  scenario 'and delete any project' do
    within(find('tr', text: 'Sublime')) do
      click_link 'X'
    end

    expect(page).to have_content 'Project has been deleted.'
    expect(page).to_not have_link 'Sublime'
    expect(page).to have_link 'VS Code'
  end
end
