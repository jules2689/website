$(document).on('page:change', function () {
  var disqusPublicKey = "s8oUrLbzLsAL371XjvtXwarHriNqscuI3kAVzzc4cKXVTnixncg5g0IAMMrdfKEx"; // Replace with your own public key
  var disqusShortname = "jnadeau"; // Replace with your own shortname

  var urlArray = [];

  $('.comment-link-marker').each(function () {
    var url = $(this).attr('data-disqus-url');
    urlArray.push('link:' + url);
  });

  $.ajax({
    type: 'GET',
    url: "https://disqus.com/api/3.0/threads/set.jsonp",
    data: { api_key: disqusPublicKey, forum : disqusShortname, thread : urlArray },
    cache: false,
    dataType: 'jsonp',
    success: function (result) {

      for (var i in result.response) {

        var countText = " comments";
        var count = result.response[i].posts;

        if (count == 1)
          countText = " comment";

        $('a[data-disqus-url="' + result.response[i].link + '"]').html(count + countText);

      }
    }
  });
});
