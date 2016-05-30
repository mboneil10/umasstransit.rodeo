require 'rails_helper'

describe 'updating a participant' do
  context 'with master of ceremonies privilege' do
    it 'updates the participant' do
      create :participant, name: 'Foo Bar'
      when_current_user_is :master_of_ceremonies
      visit participants_url
      within ('tr:nth-child(3)') do
        fill_in :participant_name, with: 'Akiva Green'
      end
      click_on 'Save'
      expect(page).to have_text 'Participant has been updated.'
    end
  end
  context 'with admin privilege' do
    it 'updates the participant' do
      create :participant, name: 'Foo Bar'
      when_current_user_is :admin
      visit participants_url
      within ('tr:nth-child(3)') do
        fill_in :participant_name, with: 'Akiva Green'
      end
      click_on 'Save'
      expect(page).to have_text 'Participant has been updated.'
    end
  end
  context 'with judge privilege' do
    it 'does not update the participant' do
      create :participant, name: 'Foo Bar'
      when_current_user_is :judge
      visit participants_url
      within ('tr:nth-child(3)') do
        fill_in :participant_name, with: 'Akiva Green'
      end
      click_on 'Save'
      expect(page).to have_text 'You are not authorized to make that action.'
    end
  end
  context 'with master of ceremonies privilege' do
    it 'will assign a number' do
      create :bus, number: 'Big Yellow Bus'
      when_current_user_is :master_of_ceremonies
      visit participants_url
      fill_in 'participant_name', with: 'Foo Bar'
      click_on 'Add'
      select('Foo Bar', from: 'id')
      select('Big Yellow Bus', from: 'bus_id')
      click_on 'Add to maneuver queue'
      expect(page).to have_text 'Participant has been added to the queue.'
    end
  end
end
