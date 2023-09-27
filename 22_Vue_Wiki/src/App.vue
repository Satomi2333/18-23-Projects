<template>
  <!-- <img alt="Vue logo" src="./assets/logo.png"> -->
  <!-- <HelloWorld msg="Welcome to Your Vue.js App"/> -->

  <github-user-card :username="username" v-for="username in usernames" :key="username"></github-user-card>
  <title-wiki></title-wiki>
  <search-container></search-container>
  
</template>

<script>
// import HelloWorld from './components/HelloWorld.vue'
import githubUserCard from './components/github-user-card.vue'
import titleWiki from './components/title-wiki.vue'
import searchContainer from './components/search-container.vue'
// import bulma from "bulma"
// import entity from './components/entity.vue'

// import axios from 'axios'
// import "jquery"
// require('bootstrap')

export default {
  name: 'App',
  // props:{
  //   username:{type:String}
  // },
  components: {
    // HelloWorld,
    githubUserCard,
    titleWiki,
    searchContainer,
    // entity,
  },
  data(){
    return{
      username:"satomi2333",
      // usernames:["satomi2333"],
      // usernames:["satomi2333","wangyunfeifeifei"],
      usernames: [],

    }
  },
}
</script>

<style>
/*<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.4.1/semantic.min.css">*/
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  /*text-align: center;*/
  color: #2c3e50;
  /*margin-top: 60px;*/
}
</style>
