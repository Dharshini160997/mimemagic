$(document).ready(function() {
  $index_table = $('.index_table');

  if ($index_table.length > 0) {
    $index_table.find('th.col.selectable .toggle_all').click(function(event) {
      $form = $(this).parents('.index_table');
      $collection_selection = $form.find('tbody .collection_selection');

      if ($(this).prop('checked')) {
        checkUncheck($collection_selection, true)
        $('.batch_action_dropdown button').removeClass('disabled');
      }else {
        checkUncheck($collection_selection, false)
        $('.batch_action_dropdown button').addClass('disabled');
      }
    });

    $index_table.find('tbody .collection_selection').click(function(event) {
      $checked = $index_table.find('tbody .collection_selection:checked').length;

      if ($checked > 0)
        $('.batch_action_dropdown button').removeClass('disabled');
      else
        $('.batch_action_dropdown button').addClass('disabled');
    });

    function checkUncheck(collection, check) {
      collection.each(function(index, el) {
        $(el).prop('checked', check);
      });
    }
  }
});
