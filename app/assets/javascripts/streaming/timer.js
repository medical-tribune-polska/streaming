//= require moment

$(document).ready(function(){
  const iframe_element = $('#streaming-iframe')
  const iframe_el = iframe_element.attr('src');
  let streamReset = false;
  let anylyticsCountdown;
  const postAnalyticsPeriod = moment.duration(1, "minute").asMilliseconds();

  $('.stream-continue-button').click(() => hideModal());

  function startSendingAnalytics() {
    anylyticsCountdown = window.setInterval(() => postAnalytics(), postAnalyticsPeriod);
  }

  function stopSendingAnalytics() {
    clearInterval(anylyticsCountdown);
  }

  var removeStream = function () {
    if (streamReset) {
      iframe_element.attr('src', '');
    }
  }

  var createStream = function () {
    iframe_element.attr('src', iframe_el);
  }

  var showModal = function () {
    const hideStreamTime = moment.duration(2, "minutes").asMilliseconds();

    $('.stream-modal').css('display', 'block');
    $('.stream-window').addClass('you-cant-see-me');
    streamReset = true;
    stopSendingAnalytics();
    window.setTimeout(() => removeStream(), hideStreamTime);
  }

  var hideModal = function () {
    $('.stream-modal').css('display', 'none');
    $('.stream-window').removeClass('you-cant-see-me');
    if (streamReset && iframe_element.attr('src') ==! iframe_el) { createStream() }
    streamReset = false;
    onLoad();
  }

  var onLoad = function () {
    const show_popup_after = parseInt(popup_time) || 30
    const countDownTime = moment.duration(show_popup_after, "minutes").asMilliseconds();
    window.setTimeout(() => showModal(), countDownTime);
    startSendingAnalytics();
  }

  function postAnalytics() {
    fetch('/stream/analytics', {
        method: 'POST',
        headers: {
          'Accept': 'application/json, text/plain, */*',
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({event_id: event_id, access_id: access_id})
    }).then(function(response) {
      var contentType = response.headers.get("content-type");
      if(contentType && contentType.includes("application/json")) {
        return response.json();
      }
      throw new TypeError("Oops, no JSON!");
    })
    .catch((err) => console.warn(err))
  }

  if(iframe_element.length > 0 && $('.stream_accesses').length > 0) {
    if (show_popup) {
      onLoad();
    } else {
      startSendingAnalytics()
    }
  }
});
