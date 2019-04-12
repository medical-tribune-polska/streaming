$(document).ready(function() {
  const show_online_block = $('#currently_online');

  if (show_online_block.length > 0) {
    url = show_online_block.data('url');
    getCurrentlyOnline(url);

    const updateEveryTime = moment.duration(30, "seconds").asMilliseconds();
    window.setInterval(() => getCurrentlyOnline(url), updateEveryTime);
  }

  async function getCurrentlyOnline(url) {
    try {
      const resp = await fetch(url, {
        method: 'GET',
        headers: {
          'Accept': 'application/json, */*',
          'Content-Type': 'application/json'
        }
      }).then(function(response) {
        var contentType = response.headers.get("content-type");
        if(contentType && contentType.includes("application/json")) {
          return response;
        }
        throw new TypeError("Oops, no JSON!");
      })
      .catch((err) => console.warn(err))

      const data = await resp.json()
      show_online_block.html(data.online_without_mt + ' / ' + data.online_all)
    } catch (err) {
      console.warn(err)
    }
  }
});
