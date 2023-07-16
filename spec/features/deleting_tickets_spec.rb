require 'rails_helper'

RSpec.feature 'Users can delete tickets' do
  let(:project) { FactoryBot.create(:project) }
  let(:bob) { FactoryBot.create(:user, email: 'bob@example.com') }
  let(:alice) { FactoryBot.create(:user, email: 'alice@example.com') }
  let(:ticket) { FactoryBot.create(:ticket, project: project, author: bob ) }

  before do
    login_as(bob)
    visit project_ticket_path(project, ticket)
  end

  scenario 'successfully' do
    click_link 'Delete Ticket'

    expect(page).to have_content 'Ticket has been deleted.'
    expect(page.current_url).to eq project_url(project)
    expect(page).to_not have_content(ticket.name)
  end

  scenario "except when they don't own the ticket or they aren't admins" do
    login_as(alice)
    page.reset!
    expect(page).to_not have_link 'Delete Ticket'
  end
end
