//= require Chart.min

$(document).ready(function(){
  var ResetHTMLTags = function (context) {
    var ui = $.summernote.ui;

    var button = ui.button({
      contents: '<i class="fa fa-child"/> Reset HTML tags',
      tooltip: 'Remove HTML classes and resets format by default',
      click: function () {
        const agendaContentEditor = $('#agenda-content-editor');
        var agendaContent = agendaContentEditor.summernote('code');
        const agendaContentWithoutClasses = agendaContent.replace(/(\sclass=\".+?\"(\s|))(.*?)/gm, "");
        $('#agenda-content-editor').summernote('code', agendaContentWithoutClasses);
        agendaContentEditor.summernote('removeFormat');
      }
    });

    return button.render();   // return button as jquery object
  }

  var ResetFormatting = function (context) {
    var ui = $.summernote.ui;

    var button = ui.button({
      contents: '<i class="fa fa-child"/> Reset format',
      tooltip: 'Resets formatting of current blocks',
      click: function () {
        const agendaContentEditor = $('#agenda-content-editor');
        agendaContentEditor.summernote('replaceWithDiv');
      }
    });

    return button.render();   // return button as jquery object
  }

  $('#agenda-content-editor').summernote({
    toolbar: [
      ['style', ['bold', 'italic', 'underline', 'clear']],
      ['para', ['ul', 'ol']],
      ['misc', ['codeview']],
      ['reset', ['resetFormatting']],
      ['resetTags', ['resetHTMLTags']]
    ],
    popover: {},
    buttons: {
      resetFormatting: ResetFormatting,
      resetHTMLTags: ResetHTMLTags
    },
    callbacks: {
      onPaste: function (e) {
        var bufferText = ((e.originalEvent || e).clipboardData || window.clipboardData).getData('Text');
        e.preventDefault();
        const text = $("<div>").html(bufferText).text();
        document.execCommand('insertText', false, text);
      }
    }
  });

  $('.add-note-button').on('click', function (ev){
    ev.preventDefault();
    var $lastNoteField = $('.stream_access_notes .note:last-of-type').clone();
    $lastNoteField.find('input').val('');
    return $(".stream_access_notes").append($lastNoteField);
  });

  $(document).on('click', '.remove-me', function(ev){
    ev.preventDefault();
    if (ev.target.tagName == 'I')
      $(ev.target).parent().parent().remove();
    else
      $(ev.target).parent().remove();
  });

  $('.add-break-button').on('click', function (ev){
    console.log('add-break-button')
    ev.preventDefault();
    var $lastBreakField = $('.stream_event_breaks .break:last-of-type').clone();
    $lastBreakField.find('input').val('');
    $(".stream_event_breaks").append($lastBreakField);
    $('.datetimepicker').datetimepicker({
      format: 'DD/MM/YYYY HH:mm',
      widgetPositioning: { vertical: 'bottom' }
    });
  });

  $(document).on('click', '.remove-break', function(ev){
    ev.preventDefault();
    if (ev.target.tagName == 'I')
      $(ev.target).parent().parent().remove();
    else
      $(ev.target).parent().remove();
  });

  $(document).on('click', '#select_all_accesses', function() {
    $('.accesses_bulk_update_checkbox').prop('checked', this.checked);
  })
});
