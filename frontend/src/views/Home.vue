<template>
  <div class="home">
    <h1>Welcome on Clash Royale: Clan Monitor</h1>

    <div class="clans">
      <h2>Check the activity of recently subscribed clans:</h2>
      <ul>
        <li><router-link to="/clans/Y8YU8L08">Pierwsza liga</router-link></li>
      </ul>
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator';
import HelloWorld from '@/components/HelloWorld.vue'; // @ is an alias to /src

@Component({
  components: {
    HelloWorld,
  },
})
export default class Home extends Vue {}
</script>
