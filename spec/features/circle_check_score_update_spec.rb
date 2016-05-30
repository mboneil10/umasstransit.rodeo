require 'rails_helper'

describe 'updating a circle check score' do
  before :each do
    create :circle_check_score, total_defects: 5, defects_found: 3
  end
  context 'with admin privilege' do
    it 'updates the circle check score' do
      when_current_user_is :admin
      visit circle_check_scores_url
      fill_in 'circle_check_score_defects_found', with: '4'
      click_on 'Save score'
      expect(page).to have_text 'Score was saved.'
      input = find_field :circle_check_score_defects_found
      expect(input.value).to eql '4'
    end
  end
  context 'with circle check scorer privilege' do
    it 'updates the circle check score' do
      when_current_user_is :circle_check_scorer
      visit circle_check_scores_url
      fill_in 'circle_check_score_defects_found', with: '4'
      click_on 'Save score'
      expect(page).to have_text 'Score was saved.'
      input = find_field :circle_check_score_defects_found
      expect(input.value).to eql '4'
    end
  end
  context 'with judge privilege' do
    it 'will not update the circle check score' do
      when_current_user_is :judge
      visit circle_check_scores_url
      fill_in 'circle_check_score_defects_found', with: '4'
      click_on 'Save score'
      expect(page).not_to have_text 'Score was saved.'
    end
  end
  context 'when out of range' do
    it 'will not accept a negative number' do
      when_current_user_is :admin
      visit circle_check_scores_url
      fill_in 'circle_check_score_defects_found', with: '-420'
      click_on 'Save score'
      expected = 'Defects found must be greater than or equal to 0'
      expect(page).to have_text expected
    end
  end
  context 'when out of range' do
    it 'will not accept a positive number greater than total points' do
      when_current_user_is :admin
      visit circle_check_scores_url
      input = find_field 'circle_check_score_total_defects'
      out_of_range = input.value.to_i + 1
      fill_in 'circle_check_score_defects_found', with: out_of_range.to_s
      click_on 'Save score'
      expected = "Defects found must be less than or equal to #{input.value}"
      expect(page).to have_text expected
    end
  end
end
