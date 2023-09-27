<template>
	<div class="columns is-centered is-multiline" id="mainBody">
		<!-- div class="column is-centered">
			<br>
		</div> -->
		<div class="column is-8 is-narrow">
			<div class="box" id="searchContainer">
				<!-- <div class="searchContainer">
					<form class="searchForm">
						<input type="radio" name="" id="radio1" v-model="inputtype" value="1">
						<label for="radio1">1.name</label>
						<input type="radio" name="" id="radio2" v-model="inputtype" value="2">
						<label for="radio2">2.entity</label>
						<input type="radio" name="" id="radio3" v-model="inputtype" value="3">
						<label for="radio3">3.entity</label>
						<input type="radio" name="" id="radio4" v-model="inputtype" value="4">
						<label for="radio4">4.entity</label>
						<div class="searchTextandButton">
							<input class="searchText" type="text" placeholder="text here" v-model="inputText">
							<input type="button" class="searchButton" @click="doSearch"> -->
							<!-- <input type="button" class="searchButton" @click="doSearch" :style="{background:icon}"> -->
					<!-- 	</div>
					</form>
				</div> -->
				<div class="columns" id="buttons">
					<div class="column is-10">
						<div class="buttons has-addons is-centered">
					<p class="control"><button class="button" id="radio1" @click="inputTypeNow1"><span>1.name</span></button></p>
					<p class="control"><button class="button" id="radio2" @click="inputTypeNow2"><span>2.entity</span></button></p>
					<p class="control"><button class="button" id="radio3" @click="inputTypeNow3"><span>3.entity</span></button></p>
					<p class="control"><button class="button" id="radio4" @click="inputTypeNow4"><span>4.entity</span></button></p>
						</div>
					</div>
					<!-- <div class="column is-6 is-centered">
						{{detail}}
					</div> -->
				</div>
				<div class="columns is-centered" id="searchTextandButton">
					<div class="column is-6">
						<input type="text" class="input" style="border-color:#161329" placeholder="search something" v-model="inputText">
					</div>
					<div class="column is-1">
						<button class="button" style="background-color:#161329" :class="loadingState" @click="doSearch">
							<span class="icon-text has-text-white">
								<i class="fas fa-search">
								</i>
							</span>
						</button>
					</div>
				</div>
				<div class="columns is-centered" id="detail">
					<div class="content">
						{{detail}}
					</div>
				</div>
			
				<!-- <input type="button" class="searchButton" @click="doSearch"> -->
				
			</div>	
		</div>
		<!-- <div v-if="!finish">loading</div> -->
		<div v-if="noData">noData</div>
		<div class="column is-7" v-if="finish">
			<div v-if="inputtype=='1'">
				<entity-template v-for="entity in returned1.data" :key="entity.id" :entity="entity"></entity-template>
			</div>
			<div v-if="inputtype=='2'">
				<category-template v-for="category in returned2.data" :key="category" :category="category">
				</category-template>
			</div>
			<div v-if="inputtype=='3'">
				<co-occur-template v-for="cooccur in returned3" :key="cooccur" :cooccurNewCommon="cooccur[0]" :cooccurNewUncommon="cooccur[1]">
				</co-occur-template>
			</div>
			<div v-if="inputtype=='4'">
				<property-template v-for="property in returned4.data" :key="property" :property="property">
				</property-template>
			</div>
		</div>
	</div>
	
	
</template>

<script>

	import axios from 'axios'
	// import searchIcon from "/src/assets/topbar.png"
	import entityTemplate from './entity.vue'
	import categoryTemplate from './category.vue'
	import coOccurTemplate from './cooccur.vue'
	import propertyTemplate from './property.vue'
	export default{
		name:"searchContainer",
		components:{
			entityTemplate,
			categoryTemplate,
			coOccurTemplate,
			propertyTemplate
		},
		data(){
			return{
				inputtype:'1',
				inputText: '', 
				detailDict:{"1":"1)	Given a name, return all the entities that match the name.","2":"2)	Given an entity, return all preceding categories (instance of and subclass of) it belongs to.","3":"3)	Given an entity, return all entities that are co-occurred with this entity in one statement.","4":"4)	Given an entity, return all the properties and statements it possesses."},
				detail:"1)	Given a name, return all the entities that match the name.",
				// icon:require("/src/assets/topbar.png"),
				returned1:{},
				returned2:{},
				returned3:{},
				returned4:{},
				// url: "http://localhost:8080/",
				url:"http://192.168.1.1:8080/",
				finish: false,
				loadingState:"",
				noData:false,
				error:"",
				lang:{
					"zh":"中文",
					"en":"英语",
					"ja":"日语",
					"fr":"法语",
					"ru":"俄语",
					"zh-cn":"简体中文",
					"zh-hans":"简体中文",

				},
			}
		},
		methods: {
			doSearch(){
				console.log(this.inputtype+this.inputText)
				this.finish = false
				this.loadingState = "is-loading"
				if(this.inputtype == "1"){
					let body = {
						"name": this.inputText,
					}
					let url = this.url+"searchEntitiesByName"
					this.search(url,body,1)
				}
				else if(this.inputtype == "2"){
					let body = {
						"eid": this.inputText,
					}
					let url = this.url+"searchCategoriesByEid"
					this.search(url,body,2)
				}
				else if(this.inputtype == "3"){
					let body = {
						"eid": this.inputText,
					}
					let url = this.url+"searchCoOccursByEid"
					this.search(url,body,3)
				}
				else if(this.inputtype == "4"){
					let body = {
						"eid": this.inputText,
					}
					let url = this.url+"searchStatementsByEid"
					this.search(url,body,4)
				}
				
			},
			search(postUrl,body,num){
				// axios({
				// 	method: "get",
				// 	url: "http://localhost:8080/searchEntitiesByName", 
				// 	data: params
				// 	})
				axios({
					url :postUrl,
					method :"post",
					data :body,
					params:
					{
						headers:{'Content-Type':'application/json;charset=UTF-8'}
					},
				})
				.then(response =>{
					// this.returned = response.data
					// toReturn = response.data
					var toread = this.returned1
					if(num==1){
						this.returned1 = response.data
						toread = this.returned1
					}
					else if(num==2){
						this.returned2 = response.data
						toread = this.returned2
					}
					else if(num==3){
						this.returned3 = response.data
						toread = this.returned3
						var dataDict = {}
						for (var index=0;index < toread.data.length;index++){
							var i = toread.data[index]
							if(dataDict[i.eid]){//存在这个条目 则添加
								if (i.language in this.lang){
									i.language = this.lang[i.language]
									dataDict[i.eid][0].push(i)
								}
								else{
									dataDict[i.eid][1].push(i)
								}
							}else{//不存在这个条目 则创建
								if (i.language in this.lang){
									i.language = this.lang[i.language]
									dataDict[i.eid] = [[i],[]]
								}
								else{
									dataDict[i.eid] = [[],[i]]
								}
							}
						}
						// console.log(dataDict)
						this.returned3 = dataDict
					}
					else if(num==4){
						this.returned4 = response.data
						toread = this.returned4
					}
					this.finish = true
					this.loadingState = ""
					console.log(toread)
					if (toread.status == 101){
						console.log(toread.msg)
						this.noData = true
					}
					this.noData = false

				}).catch(function(error){
					// this.loadingState = ""
					// this.error = error
					console.log(error)
				})
			},
			getDetail(){
				return this.detailDict[this.inputtype]
			},
			inputTypeNow(now){
				this.inputtype = now
			},
			inputTypeNow1(){this.inputtype = "1"},
			inputTypeNow2(){this.inputtype = "2"},
			inputTypeNow3(){this.inputtype = "3"},
			inputTypeNow4(){this.inputtype = "4"},
			progressData3(todoData){
				var dataDict = {}
				for (var index=0;index < todoData;index++){
					var i = todoData[index]
					if(dataDict[i.eid]){
						dataDict[i.eid].push(i)
					}else{
						dataDict[i.eid] = [i]
					}
				}
				return dataDict
			}
		},
		watch: {
			inputtype(){
				this.detail = this.getDetail()
			}
		},
	}
</script>
<style>
	/*@import "../assets/font-awesome.min.css"*/
	input[type="radio"]{
		margin: 4px;
	}
	.searchContainer{
		/*height: 70px;*/
		/*width: 800px;*/
		margin: 30px auto 0 0;
		text-align: center;
	}
	.searchForm{
		position: relative;
	}
	.searchText{
		width: 300px;
		height: 40px;
		border-radius: 18px;
		outline: none;
		border: 2px solid #ccc;
		padding-left: 20px;
		position: relative;
		left: 18px;
		font-size: 20px;
		/*font-family: Microsoft Yahei;*/
		font-weight: normal;
		color: #777;
	}
	.searchButton{
		height: 35px;
		width: 35px;
		position: relative;
		background: url("~@/assets/topbar.png") no-repeat 4px 15px;/*一定要有~号*/
		top: 5px;
		left: -20px;
		border: none;
		outline: none;
		cursor: pointer;
	}
	.searchTextandButton{
		margin-top: 20px;
	}
	.detail{
		padding-top: 30px;
		padding-bottom: 20px;
		text-align: center;
	}
</style>