require 'nokogiri'

module DataFetchers
  class WarLogPageParser
    def initialize(html)
      @page = Nokogiri::HTML(html).css(CONTAINER_CSS)
    end

    def wars
      summaries.zip(standings, participantses)
        .map(&build_war_details)
    end

    private

    def summaries
      @page.css(SUMMARIES_CSS)
    end

    def standings
      @page.css(STANDINGS_CSS)
    end

    def participantses
      @page.css(PARTICIPANTSES_CSS)
    end

    def build_war_details
      lambda do |(summary, standing, participants)|
        WarDetails.new(
          summary:      summary,
          standing:     standing,
          participants: participants
        )
      end
    end

    CONTAINER_CSS = '.content_container'.freeze

    SUMMARIES_CSS = '.ui.attached.inverted.segment'.freeze
    STANDINGS_CSS = 'table.standings'.freeze
    PARTICIPANTSES_CSS = '.detail > table'.freeze

    private_constant :CONTAINER_CSS,
      :SUMMARIES_CSS,
      :STANDINGS_CSS,
      :PARTICIPANTSES_CSS

    class WarDetails
      def initialize(summary:, standing:, participants:)
        @summary = summary
        @standing = standing
        @participants = participants
      end

      def started_at
        @summary.css(STARTED_AT_CSS)
          .text
      end

      def cards_collected
        @summary.css(CARDS_COLLECTED_CSS)
          .xpath('text()').text
          .tr(',', '')
          .to_i
      end

      def participants
        @participants.css(PARTICIPANTS_CSS)
          .map(&WarParticipant.method(:new))
      end

      STARTED_AT_CSS = '.sub.header'.freeze
      CARDS_COLLECTED_CSS = '.right.aligned.column'.freeze
      PARTICIPANTS_CSS = 'tbody > tr'.freeze

      private_constant :STARTED_AT_CSS,
        :CARDS_COLLECTED_CSS,
        :PARTICIPANTS_CSS

      class WarParticipant
        def initialize(participant)
          @participant = participant
        end

        def name
          @participant.css(NAME_CSS)
            .text.strip
        end

        def tag
          @participant.xpath(TAG_XPATH)
            .text
            .scan(TAG_REGEX).first.last
        end

        def cards_collected
          @participant.css(CARDS_COLLECTED_CSS)
            .text
            .to_i
        end

        def collection_battles
          @participant.css(COLLECTION_BATTLES_CSS)
            .text
            .to_i
        end

        def war_battles
          @participant.xpath(WAR_BATTLES_XPATH)
            .map(&:text)
            .map(&to_battle_symbol)
        end

        private

        def to_battle_symbol
          lambda do |battle_image|
            if battle_image.include?('win')
              :win
            elsif battle_image.include?('loss')
              :loss
            elsif battle_image.include?('cw-war-yet')
              :not_participated
            else
              raise "unknown battle image, #{battle_image.inspect}"
            end
          end
        end

        NAME_CSS = 'td:nth-child(2)'.freeze
        TAG_XPATH = 'td[2]/a/@href'.freeze
        COLLECTION_BATTLES_CSS = 'td:nth-child(3)'.freeze
        CARDS_COLLECTED_CSS = 'td:nth-child(4)'.freeze
        WAR_BATTLES_XPATH = 'td[5]/img/@src'.freeze

        TAG_REGEX = %r{/player/(.*)}.freeze

        private_constant :NAME_CSS,
          :TAG_XPATH,
          :COLLECTION_BATTLES_CSS,
          :CARDS_COLLECTED_CSS,
          :WAR_BATTLES_XPATH,
          :TAG_REGEX
      end
    end
  end
end
