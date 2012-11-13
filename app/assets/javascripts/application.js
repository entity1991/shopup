//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require_tree

j = jQuery.noConflict();

j(document).ready(function(){

    j("html").click(function(e){
        if (!hasParent(e.target, "signin_window") && e.target.id != 'signin_window' && e.target.id != 'sign_in') {
            j('#signin_window').hide();
        }
    });

    j("#store_name").keyup(function(){
        j("#store_domain").val(this.value.replace(/[ -]/g, '_').replace(/[`~!@#$%^&*()+=|?.,<>]/g, '').toLowerCase());
    });

//    j("#store_managing_menu a").click(function(){
//        j("#store_managing_menu a").removeClass("active_tab");
//        j(this).addClass("active_tab");
//    });

});


//functions

function toggleSigninWindow(){
    j("#signin_window").toggle();
}

function hasParent(element, parentId){
    var parentsId = j(element).parents().map(function(){return this.id}).get();
    var isParent = false;
    for(var id in parentsId){
        if(parentsId[id] != parentId) continue
        isParent = true;
    }
    return isParent;
}


