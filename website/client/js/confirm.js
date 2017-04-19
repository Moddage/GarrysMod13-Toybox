/*
 * SimpleModal Confirm Modal Dialog
 * http://simplemodal.com
 *
 * Copyright (c) 2013 Eric Martin - http://ericmmartin.com
 *
 * Licensed under the MIT license:
 *   http://www.opensource.org/licenses/mit-license.php
 */

/*
jQuery(function ($) {
	$('a.confirm_btn').click(function (e) {
		e.preventDefault();

		// example of calling the confirm function
		// you must use a callback function to perform the "yes" action
		confirm("", function () {window.location.href = "?show=comments&id="+e.attr("id");});
	});
});
*/

function confirm(message, callback, id) {
	var conf = '#confirm'+id;
	var msg = '#message'+id;
	var yes = '#yes'+id;
	console.log(id);
	
	$(conf).modal({
		closeHTML: "<a href='#' title='Close' class='modal-close'>x</a>",
		position: ["20%",],
		overlayId: 'confirm-overlay',
		containerId: 'confirm-container', 
		onShow: function (dialog) {
			var modal = this;

			$(msg, dialog.data[0]).append(message);

			// if the user clicks "yes"
			$(yes, dialog.data[0]).click(function () {
				// call the callback
				if ($.isFunction(callback)) {
					callback.apply();
				}
				// close the dialog
				modal.close(); // or $.modal.close();
			});
		}
	});
}