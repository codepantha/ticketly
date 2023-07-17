require 'rails_helper'

RSpec.feature 'Admins can manage tickets' do
  let!(:project) {FactoryBot.create(:project, name: 'Visual Studio Code')}
  let!(:ticket) {FactoryBot.create(:ticket, project: project)}

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
end
