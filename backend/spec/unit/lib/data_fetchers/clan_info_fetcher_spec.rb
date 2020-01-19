require 'data_fetchers/clan_info_fetcher'

RSpec.describe DataFetchers::ClanInfoFetcher do
  subject(:instance) { described_class.new }

  describe '#call' do
    subject(:call) { instance.call(clan_tag) }

    context 'with `Pierwsza liga`s Tag' do
      include_context :royaleapi_clan_cassette

      it_behaves_like :success

      describe 'Clan data' do
        subject(:clan) { call.value! }

        it { is_expected.to have_attributes(name: 'Pierwsza liga') }
        it { is_expected.to have_attributes(tag: clan_tag) }

        describe '#members' do
          subject(:members) { clan.members }

          describe 'leader' do
            subject(:member) { members.find { |m| m.rank == :leader } }

            it { is_expected.to have_attributes(tag: 'U8VJRG8') }
            it { is_expected.to have_attributes(username: 'John') }
            it { is_expected.to have_attributes(last_seen: '5h 22m ago') }
            it { is_expected.to have_attributes(rank: :leader) }
            it { is_expected.to have_attributes(trophies: 5253) }
            it { is_expected.to have_attributes(level: 13) }
            it { is_expected.to have_attributes(donated: 1045) }
            it { is_expected.to have_attributes(received: 397) }
          end

          describe 'co leader' do
            subject(:member) { members.find { |m| m.rank == :co_leader } }

            it { is_expected.to have_attributes(tag: '8JVQ9C8J') }
            it { is_expected.to have_attributes(username: 'WojciechKo') }
            it { is_expected.to have_attributes(last_seen: '55m ago') }
            it { is_expected.to have_attributes(rank: :co_leader) }
            it { is_expected.to have_attributes(trophies: 5134) }
            it { is_expected.to have_attributes(level: 12) }
            it { is_expected.to have_attributes(donated: 450) }
            it { is_expected.to have_attributes(received: 200) }
          end

          describe 'elder' do
            subject(:member) { members.find { |m| m.rank == :elder } }

            it { is_expected.to have_attributes(tag: 'P8UV8JVQ2') }
            it { is_expected.to have_attributes(username: 'marcel') }
            it { is_expected.to have_attributes(last_seen: '5h 46m ago') }
            it { is_expected.to have_attributes(rank: :elder) }
            it { is_expected.to have_attributes(trophies: 2871) }
            it { is_expected.to have_attributes(level: 9) }
            it { is_expected.to have_attributes(donated: 335) }
            it { is_expected.to have_attributes(received: 406) }
          end

          describe 'member' do
            subject(:member) { members.find { |m| m.rank == :member } }

            it { is_expected.to have_attributes(tag: '82LV9Q9J') }
            it { is_expected.to have_attributes(username: 'Chara <3') }
            it { is_expected.to have_attributes(last_seen: '18h 41m ago') }
            it { is_expected.to have_attributes(rank: :member) }
            it { is_expected.to have_attributes(trophies: 4313) }
            it { is_expected.to have_attributes(level: 12) }
            it { is_expected.to have_attributes(donated: 205) }
            it { is_expected.to have_attributes(received: 102) }
          end
        end
      end
    end

    context 'with invalid clan Tag' do
      include_context :royaleapi_clan_failure_cassette

      it 'return ClanNotFound failure' do
        expect(subject).to be_failure(
          DataFetchers::Errors::ClanNotFound.build(clan_tag)
        )
      end
    end

    context 'with timeout failure' do
      include_context :royaleapi_clan_timeout_failure

      it 'return UnknownError failure' do
        expect(subject).to be_failure(
          DataFetchers::Errors::UnknownError
        )
      end
    end

    context 'with 500 response' do
      include_context :royaleapi_clan_500_failure

      it 'return UnknownError failure' do
        expect(subject).to be_failure(
          DataFetchers::Errors::UnknownError
        )
      end
    end
  end
end
