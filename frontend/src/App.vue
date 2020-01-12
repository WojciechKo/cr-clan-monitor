<template>
  <div id="app" class="container">
    <TopHeader/>
    <router-view/>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator';

import TopHeader from '@/components/TopHeader.vue';

import 'typeface-roboto';

@Component({
  components: {
    TopHeader,
  },
})
export default class App extends Vue { }
</script>

<style lang="scss">
@import 'styles/css-reset';

.container {
  font-family: Roboto, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
}
</style>
