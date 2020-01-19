require 'rails_helper'

RSpec.describe ClanDataUpdater::ClanMembersUpdater do
  context 'with mocked clan_info_fetcher' do
    subject(:call) { call_with_mocked_fetcher(clan_tag, fetcher_result) }
    let(:clan_tag) { 'Y8YU8L08' }

    context 'with successful fetch' do
      let(:fetcher_result) { Success(clan_info) }

      let(:clan_info) do
        build(:clan_info_value,
              name:    'Pierwsza liga',
              tag:     clan_tag,
              members: members)
      end
      let(:members)    { [] }
      let(:clan_model) { Clan.where(tag: clan_tag).first }

      let(:alice)                  { build(:clan_member_value) }
      let(:alice_model)            { Player.where(tag: alice.tag).first }
      let(:alice_membership_model) { Membership.where(clan: clan_model, player: alice_model).first }

      let(:bob)       { build(:clan_member_value) }
      let(:bob_model) { Player.where(tag: bob.tag).first }
      let(:bob_membership_model) { Membership.where(clan: clan_model, player: bob_model).first }

      context 'executed with no member' do
        let(:members) { [] }

        it_behaves_like :success

        it 'creates a Clan' do
          expect { subject }.to change { Clan.count }.by(1)
          expect(clan_model).to have_attributes(
            tag:  clan_info.tag,
            name: clan_info.name
          )
        end

        it 'creates no Memberhip' do
          expect { subject }.to_not change { Membership.count }
        end

        it 'create no Player' do
          expect { subject }.to_not change { Player.count }
        end

        context 'then' do
          before { call_with_mocked_fetcher(clan_tag, Success(old_clan)) }
          let(:old_clan) { clan_info.new(name: 'Some Old Name', members: []) }

          it 'a Clan with old data is created' do
            expect(clan_model).to have_attributes(
              tag:  clan_info.tag,
              name: old_clan.name
            )
          end

          context 'executed with no members - again' do
            it_behaves_like :success

            it 'updates the Clan' do
              expect { subject }.to_not change { Clan.count }
              expect(clan_model).to have_attributes(
                tag:  clan_info.tag,
                name: clan_info.name
              )
            end

            it 'create no Memberhip' do
              expect { subject }.to_not change { Membership.count }
            end

            it 'create no Player' do
              expect { subject }.to_not change { Player.count }
            end
          end

          context 'executed with Alice' do
            let(:members) { [alice] }

            it_behaves_like :success

            it 'updates the Clan' do
              expect { subject }.to_not change { Clan.count }
              expect(clan_model).to have_attributes(
                tag:  clan_info.tag,
                name: clan_info.name
              )
            end

            it 'creates a Player' do
              expect { subject }.to change { Player.count }.by(1)
              expect(alice_model).to have_attributes(
                tag:      alice.tag,
                username: alice.username,
                trophies: alice.trophies,
                level:    alice.level
              )
            end

            it 'creates a Membership' do
              expect { subject }.to change { Membership.count }.by(1)
              expect(alice_membership_model).to have_attributes(
                donated:  alice.donated,
                received: alice.received,
                rank:     alice.rank.to_s
              )
            end
          end
        end
      end

      context 'executed with Alice as a member' do
        let(:members) { [alice] }

        it_behaves_like :success

        it 'creates a Clan' do
          expect { subject }.to change { Clan.count }.by(1)
          expect(clan_model).to have_attributes(
            tag:  clan_info.tag,
            name: clan_info.name
          )
        end

        it 'creates a Player' do
          expect { subject }.to change { Player.count }.by(1)
          expect(alice_model).to have_attributes(
            tag:      alice.tag,
            username: alice.username,
            trophies: alice.trophies,
            level:    alice.level
          )
        end

        it 'creates a Membership' do
          expect { subject }.to change { Membership.count }.by(1)
          expect(alice_membership_model).to have_attributes(
            donated:  alice.donated,
            received: alice.received,
            rank:     alice.rank.to_s
          )
        end

        context 'then' do
          before         { call_with_mocked_fetcher(clan_tag, Success(old_clan)) }
          let(:old_clan) { clan_info.new(members: [old_alice]) }

          let(:old_alice) do
            alice.new(
              username: 'Old Alice',
              rank:     'elder',
              level:    1,
              trophies: 2500,
              donated:  15_000,
              received: 1000
            )
          end

          it 'a Player with old data is created' do
            expect(alice_model).to have_attributes(
              username: old_alice.username,
              level:    old_alice.level,
              trophies: old_alice.trophies
            )
          end

          it 'a Membership with old data' do
            expect(alice_membership_model).to have_attributes(
              rank:     old_alice.rank.to_s,
              donated:  old_alice.donated,
              received: old_alice.received
            )
          end

          context 'executed with Alice - again' do
            let(:members) { [alice] }

            it_behaves_like :success

            it 'updates a Clan' do
              expect { subject }.to_not change { Clan.count }
              expect(clan_model).to have_attributes(
                tag:  clan_info.tag,
                name: clan_info.name
              )
            end

            it 'updates the Membership' do
              expect { subject }.to_not change { Membership.count }
              expect(alice_membership_model).to have_attributes(
                donated:  alice.donated,
                received: alice.received,
                rank:     alice.rank.to_s
              )
            end

            it 'updates the Player' do
              expect { subject }.to_not change { Player.count }
              expect(alice_model).to have_attributes(
                tag:      alice.tag,
                username: alice.username,
                trophies: alice.trophies,
                level:    alice.level
              )
            end
          end

          context 'executed with no member' do
            let(:members) { [] }

            it_behaves_like :success

            it 'create no Clan' do
              expect { subject }.to_not change { Clan.count }
            end

            it 'deletes 1 Memberships' do
              expect { subject }.to change { Membership.count }.by(-1)
            end

            it 'deletes no Player' do
              expect { subject }.to_not change { Player.count }
            end
          end

          context 'executed with Bob' do
            let(:members) { [bob] }

            it_behaves_like :success

            it 'updates the Clan' do
              expect { subject }.to_not change { Clan.count }
              expect(clan_model).to have_attributes(
                tag:  clan_info.tag,
                name: clan_info.name
              )
            end

            it 'creates a Player' do
              expect { subject }.to change { Player.count }.by(1)
              expect(bob_model).to have_attributes(
                tag:      bob.tag,
                username: bob.username,
                trophies: bob.trophies,
                level:    bob.level
              )
            end

            it 'creates 1 Membership for Bob and deletes 1 for Bob' do
              expect { subject }.to_not change { Membership.count }
              expect(bob_membership_model).to have_attributes(
                donated:  bob.donated,
                received: bob.received,
                rank:     bob.rank.to_s
              )
            end
          end
        end
      end
    end

    context 'with failed fetch' do
      context 'with plain Failue' do
        let(:fetcher_result) { Failure() }

        it_behaves_like :failure

        it 'create no Clan' do
          expect { subject }.to_not change { Clan.count }
        end

        it 'create no Player' do
          expect { subject }.to_not change { Player.count }
        end

        it 'create no Membership' do
          expect { subject }.to_not change { Membership.count }
        end
      end

      context 'with DataFetchers::Errors::ClanNotFound' do
        let(:fetcher_result) { Failure(failure) }
        let(:failure) { DataFetchers::Errors::ClanNotFound.build(clan_tag) }

        it 'returns ClanDataUpdater::Errors::ClanNotFound failure' do
          expect(subject).to be_failure(ClanDataUpdater::Errors::ClanNotFound)
        end

        it 'create no Clan' do
          expect { subject }.to_not change { Clan.count }
        end

        it 'create no  Player' do
          expect { subject }.to_not change { Player.count }
        end

        it 'create no Membership' do
          expect { subject }.to_not change { Membership.count }
        end
      end
    end
  end

  def call_with_mocked_fetcher(clan_tag, fetcher_result)
    fetcher = instance_double('DataFetchers::ClanInfoFetcher', call: fetcher_result)

    result = nil
    Container.stub('data_fetchers.clan_info_fetcher', fetcher) do
      result = described_class.new.call(clan_tag)
    end
    result
  end
end
