require 'nokogiri'

module DataFetchers
  class ClanInfoPageParser
    def initialize(html)
      @page = Nokogiri::HTML(html)
    end

    def name
      @page.css(NAME_CSS)
        .text.strip
    end

    def tag
      @page.css(TAG_CSS)
        .text.strip.tr('#', '')
    end

    def members
      @page.css(MEMBER_CSS)
        .map(&Member.method(:new))
    end

    NAME_CSS = 'h1'.freeze
    TAG_CSS = '#page_content > div:nth-child(6) > div.ui.top.attached.padded.segment > div.ui.horizontal.list > div:nth-child(1)'.freeze
    MEMBER_CSS = '#roster > tbody > tr.tr_member'.freeze

    private_constant :NAME_CSS,
                     :TAG_CSS,
                     :MEMBER_CSS

    class Member
      def initialize(member)
        @member = member
      end

      def rank
        @member.css(RANK_CSS)
          .text.tr('-', '_')
          .downcase
          .to_sym
      end

      def tag
        @member.css(TAG_CSS)
          .text.strip
      end

      def trophies
        @member.css(TROPHIES_CSS)
          .text.tr(',', '')
          .to_i
      end

      def level
        @member.css(LEVEL_CSS)
          .text
          .to_i
      end

      def name
        @member.xpath(NAME_XPATH)
          .to_s.strip
          .then(&CGI.method(:unescapeHTML))
      end

      def last_seen
        @member.css(LAST_SEEN_CSS)
          .text.to_s
          .strip
      end

      def donated
        @member.css(DONATED_CSS)
          .text.tr(',', '')
          .to_i
      end

      def received
        @member.css(RECEIVED_CSS)
          .text.tr(',', '')
          .to_i
      end

      RANK_CSS = 'td:nth-child(5)'.freeze
      TAG_CSS = 'td:nth-child(6)'.freeze
      TROPHIES_CSS = 'td:nth-child(7)'.freeze
      LEVEL_CSS = 'td:nth-child(8)'.freeze
      NAME_XPATH = 'td[2]/a/text()'.freeze
      LAST_SEEN_CSS = '.last_seen'.freeze
      DONATED_CSS = 'td:nth-child(9)'.freeze
      RECEIVED_CSS = 'td:nth-child(10)'.freeze

      private_constant :RANK_CSS,
                       :TAG_CSS,
                       :TROPHIES_CSS,
                       :LEVEL_CSS,
                       :NAME_XPATH,
                       :LAST_SEEN_CSS,
                       :DONATED_CSS,
                       :RECEIVED_CSS
    end
  end
end
