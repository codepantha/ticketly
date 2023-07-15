require 'rails_helper'

RSpec.feature 'Users can update tickets' do
  let(:project) { FactoryBot.create(:project) }
  let(:ticket) { FactoryBot.create(:ticket, project: project) }
  let(:bob) { FactoryBot.create(:user, email: 'bob@example.com') }

  before do
    login_as(bob)
    visit project_ticket_path(project, ticket)
  end

  scenario 'with valid attributes' do
    click_link 'Edit Ticket'
    fill_in 'Name', with: 'Make it really shiny!'
    click_button 'Update Ticket'

    expect(page).to have_content 'Ticket has been updated.'

    within('.ticket h2') do
      expect(page).to have_content 'Make it really shiny!'
      expect(page).not_to have_content ticket.name
    end
  end

  scenario 'with invalid attributes' do
    click_link 'Edit Ticket'
    fill_in 'Name', with: ''
    click_button 'Update Ticket'

    expect(page).to have_content 'Ticket has not been updated.'
  end

  context 'when the ticket has tags' do
    before do
      ticket.tags << FactoryBot.create(:tag, name: 'Visual Testing')
      ticket.tags << FactoryBot.create(:tag, name: 'Browser')
    end

    it 'sees existing tags on edit form' do
      click_link 'Edit Ticket'
      within('.tags') do
        expect(page).to have_content('Visual Testing')
        expect(page).to have_content('Browser')
      end
    end

    it 'can add new tags to a ticket' do
      click_link 'Edit Ticket'
      fill_in 'Tags', with: 'regression, bug'
      click_button 'Update Ticket'
      expect(page).to have_content('Ticket has been updated.')

      within('.ticket .attributes .tags') do
        expect(page).to have_content('Visual Testing')
        expect(page).to have_content('Browser')
        expect(page).to have_content('Regression')
        expect(page).to have_content('Bug')
      end
    end
  end
end
