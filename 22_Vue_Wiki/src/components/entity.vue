<template>
	<!-- <div>
		we have id:{{entity.id}}, and type:{{entity.type}}
	</div> -->
	<div class="card mb-3">
		<div class="card-content">
			<p class="title">ID:{{entity.id}}</p>
			<p class="subtitle">Type:{{entity.type}}</p>
		</div>
	</div>
</template>
<script>
	// import bulma from "bulma"
	
	export default{
		name:"entity-template",
		props:["entity"],
		data(){
		}
	}
</script>
<style>
	@import "../assets/bulma.css";
	/*@import "../assets/font-awesome.min.css";*/
</style>