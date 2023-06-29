require 'rails_helper'
describe Stance do
  describe 'stance choice validation' do
    let(:poll) { create :poll }
    let(:proposal) { create :poll_proposal }
    let(:ranked_choice) { create :poll_ranked_choice }
    let(:user) { create :user }

    it 'allows no stance choices for meetings / polls' do
      expect(Stance.new(poll: poll, participant: user)).to be_valid
    end

    it 'requires a stance choice for proposals' do
      expect(Stance.new(poll: proposal, participant: user, cast_at: Time.zone.now)).to_not be_valid
    end

    it 'requires a certain number of stance choices to be passed' do
      expect(Stance.new(poll: ranked_choice, participant: user, choice: ['apple'])).to_not be_valid
    end
  end

  describe 'statement' do
    it 'has a length validation' do
      expect(build(:stance, reason: "a"*505, cast_at: Time.now)).to_not be_valid
    end
  end

  describe 'choice shorthand' do
    let(:poll) { Poll.create!(poll_type: 'poll', maximum_stance_choices: 2, title: 'which pet?', poll_option_names: %w[dog cat], closing_at: 1.day.from_now, author: author)}
    let(:author) { FactoryBot.create(:user) }

    it "string" do
      stance = Stance.create(poll: poll, participant: author, choice: 'dog')
      poll.update_counts!
      expect(poll.stance_counts).to eq([1,0])
    end

    it "array" do
      stance = Stance.create!(poll: poll, participant: author, choice: ['dog', 'cat'])
      poll.update_counts!
      expect(poll.stance_counts).to eq([1,1])
    end
  end
end
