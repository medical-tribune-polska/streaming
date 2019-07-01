$(document).ready(function() {
  const show_online_block = $('#currently_online');

  const getCurrentlyOnline = (url) => {
    fetch(url, {
      method: 'GET',
      headers: {
        'Accept': 'application/json, */*',
        'Content-Type': 'application/json'
      }
    }).then(function (response) {
      var contentType = response.headers.get("content-type");
      if (contentType && contentType.includes("application/json")) {
        return response.json();
      }
      throw new TypeError("Oops, no JSON!");

    }).then(response => {
        show_online_block.html('Bez pracowników MT: ' + response.online_without_mt + ' / Wszyscy: ' + response.online_all);

    }).catch((err) => console.warn(err))
  };

  if (show_online_block.length > 0) {
    const url = show_online_block.data('url');
    getCurrentlyOnline(url);

    const updateEveryTime = moment.duration(30, "seconds").asMilliseconds();
    window.setInterval(() => getCurrentlyOnline(url), updateEveryTime);
  }
});
