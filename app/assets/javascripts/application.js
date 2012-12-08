//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require_tree

j = jQuery.noConflict();

j(document).ready(function(){

    j("html").click(function(e){
        autoHiding(e, "signin_window");
        autoHiding(e, "stores_list");
    });

    j("#stores_list_toggler").click(function(){
        j("#stores_list").toggle();
    });

    j("#store_name").keypress(function(){
        if (j(this).val().length == 30){
            return false
        }
        j("#store_domain").val(this.value.replace(/[ -]/g, '_').replace(/[`~!@#$%^&*()+=|?.,<>]/g, '').toLowerCase());
    });

    j('.flash').animate({
        opacity: 0
    }, 5000, function() {
        j('.flash').remove();
    });

});

//functions

function toggleSigninWindow(){
    j("#signin_window").toggle();
}

function autoHiding(e, id){

    if(j("#" + id).css("display") != "none"){
        if (!hasParent(e.target, id) && e.target.id != id && e.target.id != id + "_toggler") {
            j('#' + id).hide();
        }
    }
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


