<template>
	<div class="card mb-3">
		<div class="card-content">
			<div class="title is-3">
				Co-Occur<button @click="loadMore" class="button">
					<span class="icon"><i class="fa">{{arrowNow}}</i></span>
				</button>
			</div>
			<table class="table has-text-dark is-striped">
				<thead>
					<tr>
						<th>语言</th>
						<th>id</th>
						<th>描述</th>
					</tr>
				</thead>
				<tbody>
					<tr v-for="item of cooccurNewCommon" :key="item">
						<th>{{item.language}}</th>
						<td>{{item.id}}</td>
						<td>{{item.value}}</td>
					</tr>
				</tbody>
				<tbody v-if="more">
					<tr v-for="item of cooccurNewUncommon" :key="item">
						<th>{{item.language}}</th>
						<td>{{item.id}}</td>
						<td>{{item.value}}</td>
					</tr>
				</tbody>
					
			</table>

			<!-- <div v-for="item of cooccur" :key="item">
				<p class="content is-2">{{item.value}}</p>
			</div> -->

		</div>
	</div>
</template>
<script>
	export default{
		name:"co-occur-template",
		props:["cooccurNewCommon","cooccurNewUncommon"],
		data(){
			return{
				more:false,
				arrowNow:"&#xf063",
				// cooccurNew:this.cooccur,
				// cooccurNewCommon:[],
				// cooccurNewUncommon:[],
				// eid:"",
				// lang:{
				// 	"zh":"中文",
				// 	"en":"英语",
				// 	"ja":"日语",
				// 	"fr":"法语",
				// 	"ru":"俄语",

				// },
			}
		},
		methods:{
			loadMore(){
				if(this.more){
					this.more = false
					this.arrowNow = "&#xf062"
				}else{
					this.more = true
					this.arrowNow = "&#xf063"
				}
			},
		// },
		// computed:{
			// getCommon(){
			// 	this.eid = this.cooccur[0].eid
			// 	for (var index=0;index < this.cooccurNew.length;index++){
			// 		var i = this.cooccurNew[index]
			// 		if (i.language in this.lang){
			// 			i.language = this.lang[i.language]
			// 			this.cooccurNewCommon.push(i)
			// 		}
			// 		else{
			// 			this.cooccurNewUncommon.push(i)
			// 		}
			// 	}
			// 	return this.eid
			// 	// console.log(dataDict)
			// }
		}
	}
	
</script>