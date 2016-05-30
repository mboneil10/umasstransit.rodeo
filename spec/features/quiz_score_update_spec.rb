require 'rails_helper'

describe 'updating a quiz score' do
  before :each do
    create :quiz_score, points_achieved: 50, total_points: 100
  end
  context 'with admin privilege' do
    it 'updates the quiz score' do
      when_current_user_is :admin
      visit quiz_scores_url
      fill_in 'quiz_score_points_achieved', with: '70'
      click_on 'Save score'
      expect(page).to have_text 'Quiz score was saved.'
      input = find_field :quiz_score_points_achieved
      expect(input.value).to eql '70.0'
    end
  end
  context 'with quiz scorer privilege' do
    it 'updates the quiz score' do
      when_current_user_is :quiz_scorer
      visit quiz_scores_url
      fill_in 'quiz_score_points_achieved', with: '70'
      click_on 'Save score'
      expect(page).to have_text 'Quiz score was saved.'
      input = find_field :quiz_score_points_achieved
      expect(input.value).to eql '70.0'
    end
  end
  context 'with judge privilege' do
    it 'will not update the quiz score' do
      when_current_user_is :judge
      visit quiz_scores_url
      fill_in 'quiz_score_points_achieved', with: '70'
      click_on 'Save score'
      expect(page).to have_text 'You are not authorized to make that action.'
    end
  end
  context'when out of range' do
    it 'will not accept a negative number' do
      when_current_user_is :admin
      visit quiz_scores_url
      fill_in 'quiz_score_points_achieved', with: '-14'
      click_on 'Save score'
      expected = 'Points achieved must be greater than or equal to 0'
      expect(page).to have_text expected
    end
  end
  context'when out of range' do
    it 'will not accept a positive number greater than total points' do
      when_current_user_is :admin
      visit quiz_scores_url
      input = find_field 'quiz_score_total_points'
      out_of_range = input.value.to_i + 1
      fill_in 'quiz_score_points_achieved', with: out_of_range.to_s
      click_on 'Save score'
      expected = "Points achieved must be less than or equal to #{input.value}"
      expect(page).to have_text expected
    end
  end
end
