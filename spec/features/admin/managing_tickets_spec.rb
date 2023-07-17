require 'rails_helper'

RSpec.feature 'Admins can manage tickets' do
  let!(:project) { FactoryBot.create(:project, name: 'Visual Studio Code') }
  let!(:ticket) { FactoryBot.create(:ticket, project: project, state: FactoryBot.create(:state, name: 'New')) }
  let!(:ticket2) { FactoryBot.create(:ticket, project: project, state: FactoryBot.create(:state, name: 'Open')) }
  let!(:ticket3) { FactoryBot.create(:ticket, project: project, state: FactoryBot.create(:state, name: 'Closed')) }
  let!(:ticket4) { FactoryBot.create(:ticket, project: project, state: FactoryBot.create(:state, name: 'Awesome')) }

  before do
    login_as(FactoryBot.create(:user, :admin))
    visit admin_projects_path
  end

  scenario 'and see all tickets for a given project' do
    within(find('tr', text: 'Visual Studio Code')) do
      click_link project.tickets.count
    end
    expect(page).to have_current_path(admin_project_path(project))

    within('table.tickets') do
      expect(page).to have_link ticket.name
    end
  end

  scenario 'and see all active tickets' do
    within row_item('Visual Studio Code') do
      expect(page).to have_link "#{project.tickets.active} active"
      click_link "#{project.tickets.active} active"
    end

    expect(page).to have_content 'New'
    expect(page).to have_content 'Open'
    expect(page).to have_content 'Awesome'
    expect(page).to_not have_content 'Closed'
  end

  scenario 'and can see all closed tickets' do
    within row_item('Visual Studio Code') do
      expect(page).to have_link "#{project.tickets.closed.count} closed"
      click_link "#{project.tickets.closed.count} closed"
    end

    expect(page).to have_content 'Closed'
    expect(page).to_not have_content 'New'
  end

  scenario 'and see all newly created tickets' do
    within row_item('Visual Studio Code') do
      expect(page).to have_link "#{project.tickets.newly_created.count} new"
      click_link "#{project.tickets.newly_created.count} new"
    end

    expect(page).to have_content "New"
    expect(page).to_not have_content "Open"
  end
end
