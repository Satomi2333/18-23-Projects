<template>
	<section class="hero is-large" id="heroBG">
		<div class="hero-head">
			<nav class="navbar">
				<div class="container">
					<div class="navbar-brand" style="margin:0 50px 0 50px;">
						<a href="/" class="navbar-item">
							<span class="icon-text has-text-white is-large"><i class="fas fa-spinner fa-spin"></i></span>
						</a>
						<div class="navbar-item">
							<a href="https://github.com/Satomi2333/wikiProj">
								<span class="icon has-text-white is-large">
									<i class="fab fa-github"></i>
								</span>
							</a>
						</div>
						<a href="/" class="navbar-item">
							<span class="has-text-white">Home</span>
						</a>
					</div>
					<div class="navbar-brand" id="navBarMenuHeroA">
						<a href="https://github.com/Satomi2333" class="navbar-item">
							<span class="has-text-white">
								<span class="icon-text has-text-white is-large">
									<i class="fab fa-github"></i>
								</span>
								<span>12021115031</span>
							</span>
						</a>
						<a href="https://github.com/realqinghe" class="navbar-item">
							<span class="has-text-white">
								<span class="icon-text has-text-white is-large">
									<i class="fab fa-github"></i>
								</span>
								<span>12021115027</span>
							</span>
						</a>
						<a href="/" class="navbar-item">
							<span class="has-text-white">
								<span class="icon-text has-text-white is-large">
									<i class="fab fa-github"></i>
								</span>
								<span>12021115025</span>
							</span>
						</a>
					</div>
					<div class="navbar-end">
						<a href="https://github.com/wangyunfeifeifei" class="navbar-item">
							<span class="has-text-white">
							<span>Special Thanks to </span>
							<span class="icon-text has-text-white is-large">
								<i class="fab fa-github"></i>
							</span>
							<span>12021115028</span>
							</span>
						</a>
						
						<a href="/" class="navbar-item has-text-white">WIKIDATA Project</a>
					</div>
				</div>

			</nav>
		</div>
		<!-- <div class="hero-body"> -->
			<div class="columns-center columns">
				<div class="column is-6 is-right">
					<!-- <div class="content is-large"> -->
						<p class="title has-text-white-bis title12" style="font-size:5rem">
							Wikidata Project
						</p>
						<p class="subtitle has-text-dark-blue title12" style="font-size:2rem">
							Relational Database System:
							<br>
							Design, Implementation and Query Processing of Wikidata
						</p>
					<!-- </div> -->
				</div>
				<div class="column is-6 is-right">
					<div class="earth">
						<video src="@/assets/globe-900final.h264.mp4" height="900px" width="900px" autoplay loop muted></video>
					</div>
				</div>
			<!-- </div> -->
		</div>
			
		
		
	</section>
	<!-- <h1 class="title is-1">wikidata project</h1> -->
	<!-- <h2 class="subtitle is-2">Relational Database System: -->
		<!-- <br>Design, Implementation and Query Processing of Wikidata</h2> -->
</template>
<script>
	export default{
		name:"title-wiki"
	}
</script>
<style>
/*	h1 h2{
		font-size: revert;
		font-weight: bold;
	}*/
	#heroBG{
		background-image: url('~@/assets/github3.png');
		background-size: cover; 
		background-repeat:no-repeat;
	}
	#earth{
		height: 900px;
		width: 900px;
	}
	.title12{
		display: inline-block;
		vertical-align: middle;
	}
	.columns-center{
		align-items: center;
		margin: 0 10px 0 50px !important;
	}
	.has-text-dark-blue{
		color: #8193b2 !important;
	}
</style>