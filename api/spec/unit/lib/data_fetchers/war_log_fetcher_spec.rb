require 'data_fetchers/war_log_fetcher'

RSpec.describe DataFetchers::WarLogFetcher do
  subject(:instance) { described_class.new }

  describe '#call' do
    subject(:call) { instance.call(clan_tag) }

    context 'with `Pierwsza liga`s Tag' do
      include_context :royaleapi_war_log_cassette

      it_behaves_like :success

      describe 'WarLog data' do
        subject(:war_log) { call.value! }

        describe '#wars' do
          subject(:wars) { war_log.wars }

          describe 'the most recent war' do
            subject(:war) { wars.first }

            it { is_expected.to have_attributes(started_at: '4h 48m 13s ago') }
            it { is_expected.to have_attributes(cards_collected: 6520) }

            describe '#participants' do
              subject(:participants) { war.participants }

              describe 'participant with all attacks performed' do
                subject(:participant) { participants[participant_tag] }
                let(:participant_tag) { 'U8VJRG8' }

                it { is_expected.to have_attributes(name: 'John') }
                it { is_expected.to have_attributes(tag: 'U8VJRG8') }
                it { is_expected.to have_attributes(collection_battles: 3) }
                it { is_expected.to have_attributes(cards_collected: 480) }
                it { is_expected.to have_attributes(war_battles: [:win]) }
              end

              describe 'participant without all attacks performed' do
                subject(:participant) { participants.values.find { |p| p.collection_battles != 3 } }

                it { is_expected.to have_attributes(name: 'michał') }
                it { is_expected.to have_attributes(tag: 'PL02UCRV0') }
                it { is_expected.to have_attributes(collection_battles: 2) }
                it { is_expected.to have_attributes(cards_collected: 225) }
                it { is_expected.to have_attributes(war_battles: [:not_participated]) }
              end
            end
          end
        end
      end
    end

    context 'with invalid clan Tag' do
      include_context :royaleapi_war_log_failure_cassette

      it_behaves_like :failure
    end
  end
end
