$(document).on("page:change", function(){

  var actual_tag_list = document.getElementById('tag_list');

  if (actual_tag_list != null) {
    var taggle = new Taggle('taggle', { 
      placeholder: null ,
      onTagAdd: function(event, tag) {
        actual_tag_list.value = taggle.getTagValues();
      },
      onTagRemove: function(event, tag) {
        actual_tag_list.value = taggle.getTagValues();
      }
    });

    if (taggle != 'undefined') {
      var container = taggle.getContainer();
      var input = taggle.getInput();
      input.className += ' form-control';
      input.placeholder = "Add tags...";

      $(input).autocomplete({
        serviceUrl: actual_tag_list.dataset["url"],
        appendTo: container,
        position: { at: "left bottom", of: container },
        onSelect: function (suggestion) {
          taggle.add(suggestion.value);
          $(input).val('');
          $("li.taggle").on('click', function(){
            taggle.remove($(this).find('.taggle_text').text());
          });
        }
      });

      var tags = actual_tag_list.value.split(',')
      for (var tag_idx in tags) {
        var tag = tags[tag_idx].replace(/, /g,',');
        taggle.add(tag);
      }

    }
  }
  
});
