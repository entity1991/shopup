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
        autoHiding(e, "settings_window");
        autoHiding(e, "help_window");
    });

    j("#stores_list_toggler").click(function(){
        j("#stores_list").toggle();
    });
    j("#settings_window_toggler").click(function(){
        j("#settings_window").toggle();
    });
    j("#help_window_toggler").click(function(){
        j("#help_window").toggle();
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

    //code editor

    j("#editor_settings").click(function(){
        j("#settings_window").css("display", "block")
    });
    j("#editor_help").click(function(){

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

//code editor
function quick_save(store_id, asset_id){
    j.ajax({
        url: "/admin/stores/" + store_id + "/assets/" + asset_id,
        type:"put",
        data: {asset: {file_content: editor.getValue()}},
        dataType: "json",
        beforeSend: function () {
            j("#editor_quick_save").addClass("unactive");
        },
        complete: function(){
            j("#editor_quick_save").removeClass("unactive");
        },
        error: function(err){
            show_editor_message("Something went wrong!");
        },
        success: function(data) {
            show_editor_message("Successfully saved!")
        }
   });
}

function show_editor_message(msg){
    j("#editor_footer #message").html(msg).css("opacity", "1");
    setTimeout( function(){
        j("#editor_footer #message").animate({opacity: 0}, 5000, function(){
            j("#editor_footer #message").html("").css("opacity", "1");
        });
    }, 5000);
}


