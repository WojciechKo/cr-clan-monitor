class ActivityController < ApplicationController
  def clan_war_activity
    clan = activity_repository.find_clan_war_acticity(params[:clan_tag])

    response = {
      tag:     clan.tag,
      name:    clan.name,
      members: clan.members.map do |member|
        {
          tag:               member.tag,
          username:          member.username,
          trophies:          member.trophies,
          level:             member.level,
          donated:           member.donated,
          received:          member.received,
          rank:              member.rank,
          war_participation: member.war_participation.map do |participation|
            {
              cards_collected: participation.cards_collected
            }
          end
        }
      end
    }

    render json: response
  end

  private

  def activity_repository
    ActivityMeter::ActivityRepository.new
  end
end
