describe 'removing a participant' do
  before :each do
    create :participant
  end
  context 'with admin privilege' do
    it 'removes the participant' do
      when_current_user_is :admin
      visit participants_url
      click_on 'Remove'
      expect(page).to have_text 'Participant has been removed'
    end
  end

  context 'with master of ceremonies privilege' do
    it 'removes the participant' do
      when_current_user_is :master_of_ceremonies
      visit participants_url
      click_on 'Remove'
      expect(page).to have_text 'Participant has been removed'
    end
  end

  context 'with judge privilege' do
    it 'will not remove the participant' do
      when_current_user_is :judge
      visit participants_url
      click_on 'Remove'
      expect(page).to have_text 'You are not authorized to make that action'
    end
  end
end
