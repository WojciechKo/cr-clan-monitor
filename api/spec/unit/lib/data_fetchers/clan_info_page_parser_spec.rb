require 'data_fetchers/clan_info_page_parser'

RSpec.describe DataFetchers::ClanInfoPageParser do
  subject(:page) { described_class.new(html) }

  context 'with `Pierwsza liga`s clan page' do
    let(:html) { fixture_content('pages/clan_page.html') }

    it { is_expected.to have_attributes(tag: 'Y8YU8L08') }
    it { is_expected.to have_attributes(name: 'Pierwsza liga') }

    describe '#members' do
      subject(:members) { page.members }

      describe 'first member' do
        subject(:member) { members.first }

        it { is_expected.to have_attributes(tag: 'U8VJRG8') }
        it { is_expected.to have_attributes(name: 'John') }
        it { is_expected.to have_attributes(last_seen: '6h 1m ago') }
        it { is_expected.to have_attributes(rank: :leader) }
        it { is_expected.to have_attributes(trophies: 5253) }
        it { is_expected.to have_attributes(level: 13) }
        it { is_expected.to have_attributes(donated: 1045) }
        it { is_expected.to have_attributes(received: 397) }
      end

      describe 'unescapes html from name' do
        subject(:member) do
          members.find { |m| m.name.start_with?('Chara') }
        end

        it { is_expected.to have_attributes(name: 'Chara <3') }
      end
    end
  end
end
