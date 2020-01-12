<template>
  <div>
    <ClanInfo
      :name="name"
      :tag="tag"
    />
    <ClanMember
      v-for="member in members"
      v-bind="member"
    />
  </div>
</template>

<script lang="ts">
import { Component, Prop, Vue } from 'vue-property-decorator';

import ClanInfo from '@/components/ClanInfo.vue';
import ClanMember from '@/components/ClanMember.vue';

@Component({
  components: {
    ClanInfo,
    ClanMember,
  },
})
export default class ClanView extends Vue {
  @Prop() readonly name!: string;
  @Prop() readonly tag!: string;
  @Prop() readonly members!: [];
}
</script>
