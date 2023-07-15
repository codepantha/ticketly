# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Users can view tickets' do
  let(:bob) { FactoryBot.create(:user, email: 'bob@example.com') }

  before do
    vscode = FactoryBot.create(:project, name: 'Visual Studio Code')
    FactoryBot
      .create(:ticket,
              project: vscode,
              name: 'Make it shiny!',
              description: 'Gradients! Starbursts! Oh my!')

    ie = FactoryBot.create(:project, name: 'Internet Explorer')
    FactoryBot
      .create(:ticket,
              project: ie,
              name: 'Standards Compliance',
              description: "Isn't a joke.")

    visit '/'
  end

  scenario 'for a given project' do
    click_link 'Visual Studio Code'

    expect(page).to have_content 'Make it shiny!'
    expect(page).to_not have_content 'Standards Compliance'

    login_as(bob)
    click_link 'Make it shiny!'

    within('.ticket h2') do
      expect(page).to have_content 'Make it shiny!'
    end

    expect(page).to have_content 'Gradients! Starbursts! Oh my!'
  end

  scenario 'redirect to sign in page if not authenticated' do
    click_link 'Visual Studio Code'

    expect(page).to have_content 'Make it shiny!'
    expect(page).to_not have_content 'Standards Compliance'

    click_link 'Make it shiny!'
    expect(page).to have_current_path(new_user_session_path)
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
