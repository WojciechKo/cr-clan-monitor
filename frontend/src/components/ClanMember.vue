<template>
  <p>
    {{ username }}
  </p>
</template>

<script lang="ts">
import { Component, Prop, Vue } from 'vue-property-decorator';

@Component
export default class ClanView extends Vue {
  @Prop() readonly username!: string;
}
</script>
