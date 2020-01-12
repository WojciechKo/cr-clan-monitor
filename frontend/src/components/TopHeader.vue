<template>
  <header class="header">
    <nav>
      <router-link to="/">Clan Monitor</router-link>
    </nav>
  </header>
</template>

<script lang="ts">
import { Component, Prop, Vue } from 'vue-property-decorator';

@Component
export default class TopHeader extends Vue { }
</script>

<style scoped lang="scss">
.header {
  background: #56A902;
  text-align: left;
  padding: 16px;
  font-size:  28px;

  a {
    font-weight: bold;
    color: #F8F8FF;
  }
}
</style>
