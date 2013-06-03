$(function() {
    $( "#task-tabs" ).tabs({
      select: function(event, ui) {
        $(this).find('li').removeClass('active').eq(ui.index).addClass('active');
      },
      beforeLoad: function( event, ui ) {
        ui.jqXHR.error(function() {
          ui.panel.html(
            "Ajax не свершился=(" );
        });
      },
      load: function( event, ui) {
        $(ui.panel).find('.switch')['bootstrapSwitch']();
      }
    });
  });
