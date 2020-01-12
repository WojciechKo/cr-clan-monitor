require 'faraday'
require 'operation'

require_relative 'war_log_page_parser'
require_relative 'values/war_log'

module DataFetchers
  class WarLogFetcher
    include Operation

    def call(tag)
      html = yield fetch_html(tag)
      parser = WarLogPageParser.new(html)
      war_log = build_war_log(parser)
      Success(war_log)
    end

    private

    def fetch_html(tag)
      url = url(tag)
      response = Faraday.get(url)

      return Failure() unless response.success?
      return Failure() if response.body =~ /Clan tag \S* not found \(404\)/

      Success(response.body)
    end

    def url(clan_tag)
      "https://royaleapi.com/clan/#{clan_tag}/war/log"
    end

    def build_war_log(page)
      Values::WarLog.new(
        wars: build_war(page.wars)
      )
    end

    def build_war(wars)
      wars.map do |war|
        Values::War.new(
          started_at:      war.started_at,
          cards_collected: war.cards_collected,
          participants:    build_war_participant(war.participants)
        )
      end
    end

    def build_war_participant(participants)
      participants.each_with_object({}) do |participant, hash|
        hash[participant.tag] = Values::WarParticipant.new(
          name:               participant.name,
          tag:                participant.tag,
          collection_battles: participant.collection_battles,
          war_battles:        participant.war_battles,
          cards_collected:    participant.cards_collected
        )
      end
    end
  end
end
