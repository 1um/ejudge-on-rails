$(function() {
  bind_sort();
  $("#logins_search input").keyup(function() {
    $.get($("#logins_search").attr("action"), $("#logins_search").serialize(), null, "script");
    return false;
  });
});

function bind_sort(){
    $("#logins th a").click( function() {
        $.getScript(this.href);
        return false;
    });
}
