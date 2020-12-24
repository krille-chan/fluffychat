/* Set header-click-event */
window.onload = function(e){

	$("#header_toggle_mobile").click(function () {
		$("#header_main_nav").slideToggle();
	});

	$("#content, #header_main_nav a").click(function () {
		$("#header_main_nav").slideUp();
	});

	$('a[href^="#"]').on('click',function (e) {
		e.preventDefault();

		var target = this.hash;
		var $target = $(target);

		$('html, body').stop().animate({
			'scrollTop': $target.offset().top
		}, 900, 'swing', function () {
			window.location.hash = target;
		});
	});

}

function switchToCorrectLanguage () {

	/* Switch to correct language */
	var uri = document.documentURI
	if ( uri.endsWith ( "/" ) ) uri = uri.substr(0,uri.length-1)
	var splittedUrl = uri.split("/");

	// Detect the current language
	var currentLanguage = splittedUrl[splittedUrl.length-1];
	if ( window.location.href.endsWith (".html") ) {
		currentLanguage = splittedUrl[splittedUrl.length-2];
	}

	// If there is already a language selected then stop here
	if ( languages.indexOf( currentLanguage ) !== -1 ) return;

	// Get the preferred language
	var preferredLanguageIndex = languages.indexOf(navigator.language.substr(0,2))

	if ( preferredLanguageIndex !== -1 ) {
		var preferredLanguage = languages [ preferredLanguageIndex ]
		if ( window.location.href.endsWith (".html") ) {
			splittedUrl[splittedUrl.length] = splittedUrl[splittedUrl.length-1];
			splittedUrl[splittedUrl.length-2] = preferredLanguage;
			window.location.href = splittedUrl.join("/")
		}
		else window.location.href += preferredLanguage;
	}

}


switchToCorrectLanguage ()
