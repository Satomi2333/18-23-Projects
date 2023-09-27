<template>
	<div class="card mb-3">
		<div class="card-content">
			<div class="title">
				eid:{{property.eid}}<div class="subtitle">type:{{property.type}}</div></div>
			
			<p class="content">ID:{{property.id}}</p>
			<p class="content">rk:{{property.rk}}</p>
			<p class="content">msid:{{property.msid}}</p>
		</div>
	</div>
</template>
<script>
	export default{
		name:"property-template",
		props:["property"]
	}
</script>