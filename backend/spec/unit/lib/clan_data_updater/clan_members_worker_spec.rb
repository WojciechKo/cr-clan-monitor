require 'clan_data_updater/clan_members_worker'
require 'clan_data_updater/errors'

RSpec.describe ClanDataUpdater::ClanMembersWorker, type: :worker do
  subject     { described_class.new.perform(input) }
  let(:input) { clan_tag }

  let(:clan_tag) { 'ABC' }

  context 'with mocked clan_members_updater' do
    include_context(:mock_import, 'clan_data_updater.clan_members_updater', :clan_members_updater)

    let(:clan_members_updater) do
      instance_double('ClanDataUpdater::ClanMembersUpdater', call: clan_members_updater_result)
    end

    context 'with successful response' do
      let(:clan_members_updater_result) { Success() }

      it 'calls clan_members_updater' do
        expect(clan_members_updater).to receive(:call).with(clan_tag)
        subject
      end
    end

    context 'with failure response' do
      let(:clan_members_updater_result) { Failure(error) }

      context 'with ClanDataUpdater::Errors::ClanNotFound' do
        let(:error) { ClanDataUpdater::Errors::ClanNotFound.build(clan_tag) }

        it 'does not raise an error' do
          expect { subject }.to_not raise_error
        end

        it 'calls clan_members_updater' do
          expect(clan_members_updater).to receive(:call).with(clan_tag)
          subject
        end
      end

      context 'with Unknown Error' do
        let(:error) { Error.unknown_error }

        it 'raises an error' do
          expect { subject }.to raise_error(RuntimeError, 'Unknown error')
        end

        it 'calls clan_members_updater' do
          expect(clan_members_updater).to receive(:call).with(clan_tag)
          subject rescue nil
        end
      end
    end
  end
end
