$(function() {
	var userCreateForm = $('#userCreateForm');

	var userCreateFormMessages = $('#userSettingsForm-messages');

	$(userCreateForm).submit(function(event) {
		event.preventDefault();

		var formData = $(userCreateForm).serialize();

		$.ajax({
			type: 'POST',
			url: $(userCreateForm).attr('action'),
			data: formData, 
			success: function(response) {
				$(userCreateFormMessages).removeClass('error');
				$(userCreateFormMessages).addClass('success');

				$(userCreateFormMessages).html(response);
			},
			error: function(data) {
				$(userCreateFormMessages).removeClass('success');
				$(userCreateFormMessages).addClass('error');

				if (data.responseText !== '') {
					$(userCreateFormMessages).html(data.responseText);
				} else {
					$(userCreateFormMessages).html('<div class="alert alert-danger fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Error!</strong> An error occured and your message could not be sent.</div>');
				}
			}
		});
	});

	var userSettingsForm = $('#userSettingsForm');

	var userSettingsFormMessages = $('#userSettingsForm-messages');

	$(userSettingsForm).submit(function(event) {
		event.preventDefault();

		var formData = $(userSettingsForm).serialize();

		$.ajax({
			type: 'POST',
			url: $(userSettingsForm).attr('action'),
			data: formData, 
			success: function(response) {
				$(userSettingsFormMessages).removeClass('error');
				$(userSettingsFormMessages).addClass('success');

				$(userSettingsFormMessages).html(response);

				$('#userDisplayName').val('');
				grecaptcha.reset();
			},
			error: function(data) {
				$(userSettingsFormMessages).removeClass('success');
				$(userSettingsFormMessages).addClass('error');
				grecaptcha.reset();

				if (data.responseText !== '') {
					$(userSettingsFormMessages).html(data.responseText);
				} else {
					$(userSettingsFormMessages).html('<div class="alert alert-danger fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Error!</strong> An error occured and your message could not be sent.</div>');
				}
			}
		});
	});

	var addonUploadForm = $('#addonUploadForm');

	var addonUploadFormMessages = $('#addonUploadForm-messages');

	$(addonUploadForm).submit(function(e) {
		e.preventDefault();

		var formData = new FormData($('#addonUploadForm')[0]);

		jq1.ajax($(addonUploadForm).attr('action'), {
			type: 'POST',
			url: $(addonUploadForm).attr('action'),
			data: formData,
			cache: false,
            contentType: false,
            processData: false,
			success: function(response) {
				$(addonUploadFormMessages).removeClass('error');
				$(addonUploadFormMessages).addClass('success');

				$(addonUploadFormMessages).html(response);

				$('#addonTitle').val('');
				$('#addonDescription').val('');
				$('#addonImg').val('');
				$('#addonFile').val('');
				grecaptcha.reset();
			},
			error: function(data) {
				$(addonUploadFormMessages).removeClass('success');
				$(addonUploadFormMessages).addClass('error');
				grecaptcha.reset();

				if (data.responseText !== '') {
					$(addonUploadFormMessages).html(data.responseText);
				} else {
					$(addonUploadFormMessages).html('<div class="alert alert-danger fade in out"><a href="#" class="close" data-dismiss="alert" aria-label="close" title="close">×</a><strong>Error!</strong> An error occured and your message could not be sent.</div>');
				}
			}
		});
	});
});