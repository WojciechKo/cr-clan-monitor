require 'error'

module ClanDataUpdater
  class Errors
    class ClanNotFound < Error
      def self.build(clan_tag)
        new(error:   :clan_not_found,
            message: 'Clan not found',
            meta:    { clan_tag: clan_tag })
      end
    end
  end
end
