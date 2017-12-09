var pause = false;
$(function() {
	setInterval(function(){
		if (!pause)
			$(".website .carousel-nav-right").click();
		pause=false;
	},5000);

	$(".website .carousel-nav-right").click(function(){
		pause=true;
	});
	$(".website .carousel-nav-left").click(function(){
		pause=true;
	});

	function getRandomInt(min, max) {
	  return Math.floor(Math.random() * (max - min + 1)) + min;
	}

	var rand = getRandomInt(3,5);
	var loadingtimer = 1000 * rand;
	setTimeout(function(){
		$("#loader").hide();
	},loadingtimer);

	$(".timeleft").text(rand);
	setInterval(function(){
		rand--;
		$(".timeleft").text(rand);
	},1000);

	$(".fullWindow").height($( window ).height());
	$(".fullWindow").mouseenter(function(){
		var _this = this
		$('html, body').animate({
	        scrollTop: $(_this).offset().top
	    }, 500);
	})
});


