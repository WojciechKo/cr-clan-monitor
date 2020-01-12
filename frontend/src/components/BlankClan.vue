<template>
  <div>
    <h1> ? </h1>
    <h4>Tag: {{tag}}</h4>
  </div>
</template>

<script lang="ts">
import { Component, Prop, Vue } from 'vue-property-decorator';

@Component
export default class BlankClan extends Vue {
  @Prop(String) readonly tag: string | undefined;
}
</script>
