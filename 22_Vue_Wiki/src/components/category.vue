<template>
	<div class="card mb-3">
		<div class="card-content">
			<p class="title">category:{{category}}</p>
		</div>
	</div>
</template>
<script>
	export default{
		name:"category-template",
		props:["category"],
	}
</script>