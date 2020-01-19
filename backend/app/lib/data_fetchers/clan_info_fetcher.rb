require 'faraday'
require 'operation'
require 'faraday_middleware'

require_relative 'clan_info_page_parser'
require_relative 'values/clan_info'
require_relative 'errors'

module DataFetchers
  class ClanInfoFetcher
    include Operation

    def call(tag)
      html      = yield fetch_html(tag)
      parser    = ClanInfoPageParser.new(html)
      clan_info = build_clan_info(parser)
      Success(clan_info)
    end

    private

    def fetch_html(tag)
      url      = url(tag)
      response = Faraday.new do |c|
        c.use FaradayMiddleware::FollowRedirects, limit: 5
        c.adapter Faraday.default_adapter
      end.get(url)

      case response
        when not_successful?
          Failure(Errors::UnknownError.from_response(response))
        when redirected_to_search?
          Failure(Errors::ClanNotFound.build(tag))
        else
          Success(response.body)
      end
    rescue Faraday::Error => e
      Failure(Errors::UnknownError.from_exception(e))
    end

    def not_successful?
      ->(response) { !response.success? }
    end

    def redirected_to_search?
      ->(response) { response.env.url.to_s.include?('royaleapi.com/clans/search') }
    end

    def url(clan_tag)
      "https://royaleapi.com/clan/#{clan_tag}"
    end

    def build_clan_info(page)
      Values::ClanInfo.new(
        name:    page.name,
        tag:     page.tag,
        members: page.members.map(&method(:build_clan_member))
      )
    end

    def build_clan_member(member)
      Values::ClanMember.new(
        tag:       member.tag,
        username:  member.name,
        last_seen: member.last_seen,
        rank:      member.rank,
        trophies:  member.trophies,
        level:     member.level,
        donated:   member.donated,
        received:  member.received
      )
    end
  end
end
