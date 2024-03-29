require 'rails_helper'

RSpec.feature 'Users can update tickets' do
  let(:project) { FactoryBot.create(:project) }
  let(:bob) { FactoryBot.create(:user, email: 'bob@example.com') }
  let(:alice) { FactoryBot.create(:user, email: 'alice@example.com') }
  let(:admin) { FactoryBot.create(:user, :admin) }
  let(:ticket) { FactoryBot.create(:ticket, project: project, author: bob) }

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

  context 'if they own it or are admins' do
    it 'shows error message if they aren\'t the authors or admin' do
      login_as(alice)
      click_link 'Edit Ticket'
      fill_in 'Name', with: 'Make it really shiny!'
      click_button 'Update Ticket'

      expect(page).to have_content 'Only ticket authors or admins can edit tickets'
    end

    it 'is successful if they are admins' do
      login_as(admin)

      click_link 'Edit Ticket'
      fill_in 'Name', with: 'Make it really shiny!'
      click_button 'Update Ticket'

      expect(page).to have_content 'Ticket has been updated.'
    end
  end
end
