require 'rails_helper'

RSpec.describe ClanDataUpdater::ClanMembersUpdater do
  let(:instance) { Container.resolve('clan_data_updater.clan_members_updater') }

  describe '#call' do
    subject { instance.call(clan_tag) }
    around { |e| with_real_request(clan_tag, &e) }

    context 'with valid "Pierwsza liga" response' do
      let(:clan_tag) { 'Y8YU8L08' }

      describe 'GET /clans/:clan_tag' do
        it 'does updates data from the endpoint' do
          expect { subject }
            .to change { get_json("/clans/#{clan_tag}") }
            .from(not_found_response)
            .to(clan_response)
        end
      end
    end

    context 'with unknown clan tag' do
      let(:clan_tag) { 'some-unknown-clan-tag' }

      describe 'GET /clans/:clan_tag' do
        it 'does NOT updates data from the endpoint' do
          expect { subject }
            .to_not change { get_json("/clans/#{clan_tag}") }
            .from(not_found_response)
        end
      end
    end
  end

  def with_real_request(clan_tag)
    VCR.use_cassette("clan_members_updater/#{clan_tag}", &Proc.new)
  end
end
