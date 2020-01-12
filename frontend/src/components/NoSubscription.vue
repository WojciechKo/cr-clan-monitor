<template>
  <div>
    <h1>Clan with following tag <code>{{tag}}</code> is not subscribed for monitoring.</h1>
    <h2>¯\_(ツ)_/¯</h2>
  </div>
</template>

<script lang="ts">
import { Component, Prop, Vue } from 'vue-property-decorator';

@Component
export default class NoSubscription extends Vue {
  @Prop(String) readonly tag: string | undefined;
}
</script>
