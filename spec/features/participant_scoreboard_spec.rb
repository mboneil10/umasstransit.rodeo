require 'rails_helper'

describe 'scoring appears properly' do
  let!(:participant) { create :participant }
  it 'when a participant is intialized' do
    visit scoreboard_participants_url
    expect(page).to have_text participant.total_score
  end
  it 'when a participant has a quiz score' do
    quiz_score = create :quiz_score
    participant.update quiz_score: quiz_score
    visit scoreboard_participants_url
    expect(page).to have_text quiz_score.score
  end
  it 'when a participant has a circle check score' do
    circle_check_score = create :circle_check_score
    participant.update circle_check_score: circle_check_score
    visit scoreboard_participants_url
    expect(page).to have_text circle_check_score.score
  end
  it 'when a participant has maneuver scores' do
    maneuver_participant = create :maneuver_participant, :perfect_score,
                                  participant: participant
    visit scoreboard_participants_url
    expect(page).to have_text maneuver_participant.score
  end
end

describe 'sorting functions properly' do
  let!(:participant) { create :participant }
  let!(:maneuver_score) do
    create :maneuver_participant,
           :perfect_score, reversed_direction: 1,
                           participant: participant
  end
  let!(:participant_2) { create :participant }
  let!(:maneuver_score_2) do
    create :maneuver_participant,
           :perfect_score,
           participant: participant_2
  end
  it 'by default' do
    visit scoreboard_participants_url
    expect(find('tr:nth-child(2)')).to have_text participant_2.name.to_s
  end
  it 'by maneuver score' do
    visit scoreboard_participants_url
    click_button 'Maneuver score'
    expect(find('tr:nth-child(2)')).to have_text participant_2.name.to_s
  end
  it 'by participant name' do
    visit scoreboard_participants_url
    click_button 'Participant name'
    expect(find('tr:nth-child(2)')).to have_text participant.name.to_s
  end
  it 'by participant number' do
    visit scoreboard_participants_url
    click_button 'Participant number'
    expect(find('tr:nth-child(2)')).to have_text participant.name.to_s
  end
end
