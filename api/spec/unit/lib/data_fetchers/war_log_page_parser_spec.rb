require 'data_fetchers/war_log_page_parser'

RSpec.describe DataFetchers::WarLogPageParser do
  subject(:page) { described_class.new(html) }

  context 'with `Pierwsza liga`s war log page' do
    let(:html) { fixture_content('pages/war_log_page.html') }

    describe '#wars' do
      subject(:wars) { page.wars }

      describe 'last war' do
        subject(:war) { wars[0] }

        it { is_expected.to have_attributes(started_at: '1d 14h 51m ago') }
        it { is_expected.to have_attributes(cards_collected: 4050) }

        describe '#participants' do
          subject(:participants) { war.participants }

          describe 'first participant' do
            subject(:participant) { participants[0] }

            it { is_expected.to have_attributes(name: 'marcel') }
            it { is_expected.to have_attributes(tag: 'P8UV8JVQ2') }
            it { is_expected.to have_attributes(collection_battles: 3) }
            it { is_expected.to have_attributes(cards_collected: 360) }
            it { is_expected.to have_attributes(war_battles: [:win]) }
          end

          describe 'second participant' do
            subject(:participant) { participants[1] }

            it { is_expected.to have_attributes(name: 'pawlo') }
            it { is_expected.to have_attributes(tag: 'PYVY9YG89') }
            it { is_expected.to have_attributes(collection_battles: 3) }
            it { is_expected.to have_attributes(cards_collected: 220) }
            it { is_expected.to have_attributes(war_battles: [:win]) }
          end
        end
      end

      describe 'third war ago' do
        subject(:war) { wars[2] }

        it { is_expected.to have_attributes(started_at: '5d 15h 26m ago') }
        it { is_expected.to have_attributes(cards_collected: 2715) }

        describe '#participants' do
          subject(:participants) { war.participants }

          describe 'third participant' do
            subject(:participant) { participants[2] }

            it { is_expected.to have_attributes(name: 'pawlo') }
            it { is_expected.to have_attributes(tag: 'PYVY9YG89') }
            it { is_expected.to have_attributes(collection_battles: 1) }
            it { is_expected.to have_attributes(cards_collected: 55) }
            it { is_expected.to have_attributes(war_battles: [:win, :loss]) }
          end
        end
      end
    end
  end
end
