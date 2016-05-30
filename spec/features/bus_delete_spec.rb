require 'rails_helper'

describe 'deleting a bus' do
  let!(:bus) { create :bus }
  context 'with admin privilege' do
    it 'deletes the bus' do
      when_current_user_is :admin
      visit buses_url
      click_on 'Remove'
      expect(page).not_to have_text bus.number
    end
  end

  context 'with master of ceremonies privilege' do
    it 'deletes the bus' do
      when_current_user_is :master_of_ceremonies
      visit buses_url
      click_on 'Remove'
      expect(page).not_to have_text bus.number
    end
  end

  context 'with judge privilege' do
    it 'will not delete the bus' do
      when_current_user_is :judge
      visit buses_url
      click_on 'Remove'
      expect(page).to have_text bus.number
    end
  end
end
