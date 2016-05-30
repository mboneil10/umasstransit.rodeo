require 'rails_helper'
describe ManeuverParticipant do
  describe 'score' do
    let!(:record) { create :maneuver_participant, :perfect_score }
    it 'should be a perfect score' do
      expect(record.score).to be(50)
    end

    it 'lowers by 10 for each reverse direction' do
      expect { record.update reversed_direction: 1 }
        .to change { record.score }
        .by(-10)
    end

    it 'lowers by 25 when speed target is not reached' do
      record.maneuver.update! speed_target: 25
      expect { record.update speed_achieved: false }
        .to change { record.score }
        .by(-25)
    end

    it 'lowers by 25 when made additional stops' do
      record.maneuver.update! counts_additional_stops: true
      expect { record.update made_additional_stops: true }
        .to change { record.score }
        .by(-25)
    end

    it 'lowers by 50 when not completed as designed' do
      expect { record.update completed_as_designed: false }
        .to change { record.score }
        .by(-50)
    end

    it 'lowers by the sum of each point value multiplied by count' do
      expect { record.update obstacles_hit: { 1 => 1 } }
        .to change { record.score }
        .by(-1)
    end

    context 'lowers by the positive difference' do
      it 'between each distance and the minimum multiplied by the multiplier' do
        expect { record.update distances_achieved: { [0, 1] => 1 } }
          .to change { record.score }
          .by(-1)
      end
    end

    context 'lowers by negative difference' do
      it 'between each distance and the minimum multiplied by the multiplier' do
        expect { record.update distances_achieved: { [1, 1] => 0 } }
          .to change { record.score }
          .by(0)
      end
    end
  end

  context 'previous participant' do
    let!(:maneuver) { create :maneuver }
    let!(:record_1) { create :maneuver_participant, maneuver: maneuver }
    let!(:record_2) { create :maneuver_participant, maneuver: maneuver }
    it 'finds previous participant' do
      actual = record_2.participant.number
      expect(maneuver.previous_participant(actual)).to eql record_1.participant
    end
    it 'finds previous participant with no argument' do
      expect(maneuver.previous_participant.id).to be record_2.participant.id
    end
  end

  context 'next participant' do
    let!(:maneuver) { create :maneuver }
    let!(:record_1) { create :maneuver_participant, maneuver: maneuver }
    let!(:record_2) { create :maneuver_participant, maneuver: maneuver }
    it 'finds the next participant' do
      actual = record_1.participant.number
      expect(maneuver.next_participant(actual)).to eql record_2.participant
    end
  end
end
