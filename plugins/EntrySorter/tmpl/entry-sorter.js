(function($) {
  $('#entry-sorter-start').click(function() {
    if ( $('#entry-table tbody tr[id]').length < 1 ) {
      alert($(this).data('no-entries'));
      return false;
    }

    $(this).hide();
    $('#entry-sorter-update, #entry-sorter-cancel').show();

    $('#entry-table tbody tr').each(function() {
      // var id = $(this).attr('id');
      $(this).find('.col.cb [type=checkbox]').hide().after($('<span class="sort-tab" style="position: relative; height: 24px"> </span>'));
    });

    $('#entry-table tbody').sortable({
      handle: '.sort-tab',
    }).selectable({
      cancel: '.sort-tab',
    });

  });

  $('#entry-sorter-update').click(function() {
    if ( confirm($(this).data('confirm') ) ) {
      var ids = $('#entry-table tbody tr[id]').map(function() {
        return $(this).attr('id');
      }).get().join();
      var href = $(this).attr('href');

      $(this).attr('href', href + '&ids=' + encodeURIComponent(ids)); // Join with ,
    } else {
      return false;
    }
  });

  $('#entry-sorter-cancel').click(function() {
    $('#entry-table tbody tr').each(function() {
      $(this).find('.col.cb [type=checkbox]').show();
      $(this).find('.sort-tab').remove();
    });

    $('#entry-sorter-update, #entry-sorter-cancel').hide();
    $('#entry-sorter-start').show();
  });

})(jQuery);
