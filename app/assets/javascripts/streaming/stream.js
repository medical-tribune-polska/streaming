//= require jquery
//= require jquery-ui

//= require moment
//= require bootstrap-datetimepicker
//= require select2
//= require summernote

//= require streaming/form
//= require streaming/timer
//= require streaming/count_online

function copyToClipboard (str) {
   var el = document.createElement('textarea');
   el.value = str;
   el.setAttribute('readonly', '');
   el.style = {position: 'absolute', left: '-9999px'};
   document.body.appendChild(el);
   el.select();
   document.execCommand('copy');
   document.body.removeChild(el);
}

$(document).ready(function() {
  $('.copy-link').click(function(event){
    text_to_copy = event.target.getAttribute('data-copy');
    if (text_to_copy === null)
      text_to_copy = event.target.parentElement.getAttribute('data-copy');

    if (event.target.getAttribute('data-text') !== null) {
      text_to_change = event.target.getAttribute('data-text');
      original_text = event.target.innerHTML;
      event.target.innerHTML = text_to_change;
      setTimeout(function() { event.target.innerHTML = original_text; }, 3000);
    }

    copyToClipboard(text_to_copy);
    event.preventDefault();
  });

  $('.datetimepicker').datetimepicker({
    format: 'DD/MM/YYYY HH:mm',
    widgetPositioning: { vertical: 'bottom' }
  });
});

$(document).on('click', '.remove-access', function(e) {
  e.preventDefault();
  $(e.target).parents('.well').remove();
});


$(document).on('click', '.submit_paid_status', function(e) {
  action = event.target.getAttribute('data-action');
  $('.access-action').val(action);
});

$(document).on('click', '#access-form-bulk-select-action', function(e) {
  e.preventDefault();
  action = $(e.target).attr('data-action');

  if (action === 'change_paid_status') {
    $(e.target).attr('data-action', 'change_test_results');
    e.target.innerHTML = 'Przełącz na tryb zmiany statusów płatnośći';
    $('.show-when-test-result').show();
    $('.show-when-test-result input.form-control').prop('disabled', false);
    $('.show-when-paid-status').hide();
    $('.show-when-paid-status input[type=checkbox]').prop('disabled', true);
  }

  if (action === 'change_test_results') {
    $(e.target).attr('data-action', 'change_paid_status');
    e.target.innerHTML = 'Przełącz na tryb zmiany wyników testu';
    $('.show-when-test-result').hide();
    $('.show-when-test-result input.form-control').prop('disabled', true);
    $('.show-when-paid-status').show();
    $('.show-when-paid-status input[type=checkbox]').prop('disabled', false);
  }
});
