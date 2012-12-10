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

    j('.flash').animate({
        opacity: 0
    }, 5000, function() {
        j('.flash').remove();
    });


    j("img.editing").mouseover(function(){
        j(this).wrap("<div class='img_wrapper'  style='width:" + j(this).css("width") + "'></div>");
        j(this).after("<div class='change_image' style='width:" + j(this).css("width") + "'>change another</div>");
        j(this).parent().css("height", j(this).css("height"));
        j(".change_image").animate({marginTop: "-=" + j(".change_image").css("height") }, 150);
        j(this).mouseout(function(){
            j(this).next("div.change_image").remove();
            if (j(this).parent().attr("class") == "img_wrapper"){
                j(this).unwrap();
            }
        });
    });


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


