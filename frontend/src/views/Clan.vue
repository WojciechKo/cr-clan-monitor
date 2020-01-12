<template>
  <div class="clan">
    <ClanView
      v-if="clan"
      v-bind="clan"
    />
    <NoSubscription
      v-else-if="noSubscription"
      :tag="this.$route.params.clan_tag"
    />
    <ClanFailure
      v-else-if="failure"
    />
    <BlankClan
      v-else
      :tag="this.$route.params.clan_tag"
    />
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator';
import { oc } from 'ts-optchain';

import ClanRepository from '@/services/clan_repository';

import ClanView from '@/components/ClanView.vue';
import NoSubscription from '@/components/NoSubscription.vue';
import ClanFailure from '@/components/ClanFailure.vue';
import BlankClan from '@/components/BlankClan.vue';

@Component({
  components: {
    ClanView,
    NoSubscription,
    ClanFailure,
    BlankClan,
  },
})
export default class Clan extends Vue {
  private clan = null;
  private noSubscription = false;
  private failure = null;

  mounted() {
    const clan_tag = this.$route.params.clan_tag;

    new ClanRepository().fetch_clan(clan_tag)
      .then(this.update_clan_data)
      .catch(this.handle_failure);
  }

  update_clan_data(response: any) {
    this.clan = response.data;
  }

  handle_failure(failure: any) {
    if (oc(failure).response.status() === 404) {
      this.noSubscription = true;
    }
    this.failure = failure;
  }
}
</script>
