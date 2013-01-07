//= require jquery

j = jQuery.noConflict();
j(document).ready(function(){
    j("#toggle_admin_panel").toggle(function(){
        j("#admin_wrapper").addClass("minimized");
        j(this).html("admin");
    }, function(){
        j("#admin_wrapper").removeClass("minimized");
        j(this).html("X");
    });
});