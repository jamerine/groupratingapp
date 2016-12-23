$(function() {
  $(".pagination a").live("click", function() {
    $.git(this.href, null, null, "script");
    return false;
  });
});
