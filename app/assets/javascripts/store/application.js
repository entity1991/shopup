// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree

j = jQuery.noConflict();

j(document).ready(function(){

    j("html").click(function(e){
        if (!hasParent(e.target, "signin_window") && e.target.id != 'signin_window' && e.target.id != 'sign_in') {
            j('#signin_window').hide();
        }
    });

});


//functions

//function toggleSigninWindow(){
//    j("#signin_window").toggle();
//}
//
//function hasParent(element, parentId){
//    var parentsId = j(element).parents().map(function(){return this.id}).get();
//    var isParent = false;
//    for(var id in parentsId){
//        if(parentsId[id] != parentId) continue
//        isParent = true;
//    }
//    return isParent;
//}


