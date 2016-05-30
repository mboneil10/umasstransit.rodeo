require 'rails_helper'

describe 'adding a participant' do
  context 'with master of ceremonies privilege' do
    it 'adds the participant' do
      when_current_user_is :master_of_ceremonies
      visit participants_url
      fill_in 'participant_name', with: 'Foo Bar'
      click_on 'Add'
      expect(page).to have_text 'Participant was successfully created.'
    end
  end
  context 'with admin privilege' do
    it 'adds the participant' do
      when_current_user_is :admin
      visit participants_url
      fill_in 'participant_name', with: 'Foo Bar'
      click_on 'Add'
      expect(page).to have_text 'Participant was successfully created.'
    end
  end
  context 'with judge privilege' do
    it 'does not add the participant' do
      when_current_user_is :judge
      visit participants_url
      fill_in 'participant_name', with: 'Foo Bar'
      click_on 'Add'
      expect(page).to have_text 'You are not authorized to make that action.'
    end
  end
  context 'that is a duplicate' do
    it 'will not add the participant' do
      when_current_user_is :admin
      create :participant, name: 'Foo Bar'
      visit participants_url
      within('tr:nth-child(2)') do
        fill_in :participant_name, with: 'Foo Bar'
      end
      click_on 'Add'
      expect(page).to have_text 'Name has already been taken'
    end
  end
  context 'with a unique number and bus number' do
    it 'will add the participant' do
      create :bus, number: 'Big Yellow Bus'
      when_current_user_is :admin
      visit participants_url
      fill_in 'participant_name', with: 'Foo Bar'
      fill_in 'participant_number', with: '1'
      select('Big Yellow Bus', from: 'participant_bus_id')
      click_on 'Add'
      expect(page).to have_text 'Participant was successfully created.'
    end
  end
  context 'with a unique number and no bus number' do
    it 'will not add the participant' do
      when_current_user_is :admin
      visit participants_url
      fill_in 'participant_name', with: 'Foo Bar'
      fill_in 'participant_number', with: '1'
      click_on 'Add'
      expect(page).to have_text "Bus can't be blank"
    end
  end
  context 'with blank fields' do
    it 'will not add the participant' do
      when_current_user_is :admin
      visit participants_url
      click_on 'Add'
      expect(page).to have_text "Name can't be blank"
    end
  end
end
