require 'rails_helper'

RSpec.describe 'GET /clans/:clan_tag -> Show the summary of the clan war activity' do
  subject(:do_request) { get "/clans/#{clan_tag}"; response }

  let(:clan_tag) { 'ABCXYZ' }

  context 'with not existing clan' do
    it { is_expected.to have_attributes(status: 404) }

    describe 'response json' do
      subject(:response_json) do
        do_request
        parse_response
      end

      it { is_expected.to match(not_found_response) }
    end
  end

  context 'with existing clan' do
    let!(:clan) { create(:clan, tag: clan_tag) }

    it { is_expected.to have_attributes(status: 200) }

    describe 'response json' do
      subject(:response_json) do
        do_request
        parse_response
      end

      it { expect(response_json).to match(clan_response) }

      describe '#tag' do
        subject(:response_tag) { response_json['tag'] }

        it { is_expected.to eq(clan_tag) }
      end

      describe '#name' do
        subject(:response_name) { response_json['name'] }

        it { is_expected.to eq(clan.name) }
      end

      describe '#members' do
        before { create(:player) }
        subject(:response_members) { response_json['members'] }

        context 'wihout any members' do
          it { is_expected.to eq([]) }
        end

        context 'with some clan members' do
          let!(:alice)            { create(:player) }
          let!(:alice_membership) { create(:membership, player: alice, clan: clan) }

          let!(:bob)            { create(:player) }
          let!(:bob_membership) { create(:membership, player: bob, clan: clan) }

          let!(:charlie) { create(:player, clan: clan) }

          it { is_expected.to have_attributes(size: 3) }

          it { expect(response_json).to match(clan_response) }

          describe 'Alice' do
            subject(:member_alice) { response_json['members'].find { |m| m['tag'] == alice.tag } }

            it 'returns correct values' do
              expect(subject).to include(
                'tag' => alice.tag,
                'username' => alice.username,
                'trophies' => alice.trophies,
                'level' => alice.level,
                'donated' => alice.membership.donated,
                'received' => alice.membership.received,
                'rank' => alice.membership.rank
              )
            end

            describe '#war_participation' do
              subject(:response_war_participation) { member_alice['war_participation'] }

              context 'without any War played by the Clan' do
                it { is_expected.to be_empty }
              end

              context 'with a War played by the Clan' do
                let!(:war) { create(:war, clan: clan) }

                context 'with no participation in the War' do
                  it { is_expected.to have_attributes(size: 1) }

                  describe 'First war' do
                    subject(:response_last_participation) { response_war_participation.first }

                    it { is_expected.to include('cards_collected' => 0) }
                  end
                end

                context "with Alice's participation in the War" do
                  before do
                    create(:participation,
                           war:             war,
                           membership:      alice_membership,
                           cards_collected: cards_collected)
                  end
                  let(:cards_collected) { 245 }

                  it { is_expected.to have_attributes(size: 1) }

                  describe 'First war' do
                    subject(:response_last_participation) { response_war_participation.first }

                    it { is_expected.to include('cards_collected' => cards_collected) }
                  end
                end

                context "with Bob's participation in the War" do
                  before { create(:participation, war: war, membership: bob_membership) }

                  it { is_expected.to have_attributes(size: 1) }

                  describe 'First war' do
                    subject(:response_last_participation) { response_war_participation.first }

                    it { is_expected.to include('cards_collected' => 0) }
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
