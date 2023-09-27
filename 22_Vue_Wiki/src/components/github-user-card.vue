<template>
	<div class="ui card">
		<div class="image">
			<img :src="user.avatar_url">
		</div>
		<div class="content">
			<a :href="`https://github.com/${username}`" class="header">{{user.name}}</a>
			<div class="meta">
				<span class="date">Joined in {{user.created_at}}</span>
			</div>
			<div class="description">{{user.bio}}</div>
		</div>
		<div class="extra content">
		<a :href="`https://github.com/${username}?tab=followers`">
			<i class="user icon"></i>
			{{user.followers}} Friends
		</a>
		</div>
	</div>
</template>
<script>
	import axios from 'axios'
	export default{
		name:'github-user-card',
		props: {
			// user:Object,
			username:String
		},
		data(){
			return{
				user:{},
				// username:"satomi2333"
				// usernames:["satomi2333"]
			}
		},
		async created(){
		const response = await axios.get(`https://api.github.com/users/${this.username}`)
		this.user = response.data
		}
	}
</script>

<!-- <style>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.4.1/semantic.min.css">
</style> -->
