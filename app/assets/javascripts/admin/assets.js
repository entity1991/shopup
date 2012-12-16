var editors = {};
var editor_vars = {};
var theme = "default";
var ln = true;
var font_size = "1";
var store;
var fullscreen = false;

j(document).ready(function(){
    j(".assets_box_title").append("<div class='assets_box_toggler'></div>");
    j(".assets_box_toggler").toggle(function(){
        j(this).parent().next(".asset_items").hide();
        j(this).addClass("hidden");
    }, function(){
        j(this).parent().next(".asset_items").show();
        j(this).removeClass("hidden");
        j("#uploaded_assets_list").html("");
    });

    j("form#new_asset").submit(function() {
         if (j(this).find("#asset_file").val() == ""){
             return false;
         }
    });
    j("form #asset_file").change(function(){
        if(this.value != ""){
            j("form#new_asset input[type=submit]").show();

            document.getElementById("asset_file");
        }
        else{
            j("form#new_asset input[type=submit]").hide();
        }
    });

    j(window).resize(function () {
//        if (fullscreen == true){
//            var header_height = parseInt(j("#editor_header").css("height").replace("px", ""));
//            var footer_height = parseInt(j("#editor_footer").css("height").replace("px", ""));
//            j("#editor_right_menu").css("height", (winHeight()-header_height-footer_height) + "px");
//            for(var e in editors){
//                j(editors[e].getTextArea()).next(".CodeMirror").find(".CodeMirror-scroll")
//                    .css("height", (winHeight()-header_height-footer_height) + "px");
//                editors[e].refresh();
//            }
//        }
    });

    j(".right_window_opener").click(function(){
        j("#editor_right_menu").show();
    });
    j("#settings_window_icon").click(function(){
        j("#editor_right_menu .editor_right_window").hide();
        j("#settings_window").show();
    });
    j("#help_window_icon").click(function(){
        j("#editor_right_menu .editor_right_window").hide();
        j("#help_window").show();
    });

    j("#right_editor_menu_close").click(function(){
        j(this).parent().css("display", "none");
        refreshEditor();
    });

    if(theme != "default"){
      j("#select_theme option[value='default']").removeAttr("selected");
      j("#select_theme option[value=" + theme + "]").attr("selected", "selected");
    }
    var input = document.getElementById("select_theme");
    j("#select_theme").change(function(){
        var selected_theme = input.options[input.selectedIndex].innerHTML;
        theme = selected_theme;
        for(var id in editors){
            editors[id].setOption("theme", selected_theme);
        }
        j.get("/change_editor_theme/" + selected_theme);
    });

    if(ln == "true"){
        j("#editor_toggle_ln").attr("checked", true);
    }
    j("#editor_toggle_ln").click(function(){
        for(var id in editors) editors[id].setOption("lineNumbers", this.checked);
        ln = this.checked.toString();
        j.get("/change_editor_ln/" + this.checked);
    });

    j("#editor_font_size").val(font_size);
    j(".CodeMirror").css("font-size", ((parseInt(font_size))/10).toString() + "em");
    j("#editor_font_size").change(function(){
        font_size = this.value;
        j(".CodeMirror").css("font-size", ((parseInt(this.value))/10).toString() + "em");
        j.get("/change_editor_font_size/" + this.value);
        refreshEditor();
    });
});

//functions

function markerNewAsset(){
    j(".just_now_added_asset").append("<div class='new_asset_plus'>new file</div>");
    j(".just_now_added_asset").removeClass("just_now_added_asset").addClass("new_asset");
    j(".new_asset").click(function(){
        j(this).find(".new_asset_plus").animate({opacity: 0}, 10000, function(){
            j(this).remove();
            j(this).parent(".new_asset").removeClass("new_asset");
        }
        );
    });
}

function changeUndoRedoColor(editor_id){
    if(editors[editor_id].historySize().redo > 0){
      j("#arrow_redo_icon").addClass("arrow_redo_icon_active");
    } else{
      j("#arrow_redo_icon").removeClass("arrow_redo_icon_active");
    }
    if(editors[editor_id].historySize().undo > 0){
      j("#arrow_undo_icon").addClass("arrow_undo_icon_active");
    } else{
      j("#arrow_undo_icon").removeClass("arrow_undo_icon_active");
    }
}
function refreshEditor(){
    for(var id in editors){
        editors[id].refresh();
    }
}

function loadAsset(store_id, asset_id){
    if(j(".asset_item.selected_asset#asset_" + asset_id).length == 0){
        store = store_id;
        j(".editor_content").next(".CodeMirror").hide();
        j(".asset_item").removeClass("selected_asset");
        j("#asset_" + asset_id).addClass("selected_asset");
        j("#editor_footer #message").html("");
        if(j("#editor_" + asset_id).length == 0){
            j.ajax({
                url: "/admin/stores/" + store_id + "/assets/" + asset_id + "/load_asset",
                type:"get",
                data: {asset_id: asset_id},
                dataType: "json",
                success: function(data) {
                    j(".editor_title").html(data.name);
                    var editor_content = "<textarea id='editor_" + asset_id + "' class='editor_content'>" + data.content + "</textarea>";
                    j("#editor_right_menu").after(editor_content);
                    j("#arrow_redo_icon").removeClass("arrow_redo_icon_active");
                    j("#arrow_undo_icon").removeClass("arrow_undo_icon_active");
                    if(j("#editor_footer").length == 0){
                        var editor_footer =
                            "<div id='editor_footer'>"+
                                "<div class='button green float_r' id='editor_save_all'>Save all</div>"+
                                "<div class='button grey float_r' id='editor_quick_save'>Quick save</div>"+
                                "<div id='message' class='float_r'></div>"+
                                "<div id='editor_autoformat' class='button grey'>Autoformat</div>"+
                            "</div>"
                        j("#editor_" + asset_id).after(editor_footer);
                    }
                    initializeEditor("editor_" + asset_id, data.type);
                }
            });
        } else {
            j(".editor_title").html(j("#asset_" + asset_id).html());
            j("#editor_" + asset_id).next(".CodeMirror").show();
            changeUndoRedoColor("editor_" + asset_id);
        }
    }
}

function initializeEditor(id, mode){
    editor_vars[id] = {changed: false, asset_id: id.split("_")[1]};
    editors[id] = CodeMirror.fromTextArea(document.getElementById(id), {
      lineNumbers: true,
      lineWrapping: true,// ?
      mode: mode,
      tabSize: 4,
      indentUnit: 4,    // ?
      indentWithTabs: true, // ?
      onCursorActivity: function() {
        editors[id].setLineClass(hlLine, null, null);
        hlLine = editors[id].setLineClass(editors[id].getCursor().line, null, "activeLine");
        editors[id].matchHighlight("CodeMirror-matchhighlight");
      },
      extraKeys: {
        "F11": function(editor) {
          setFullScreen(editor, !isFullScreen(editor));
        },
        "Esc": function(editor) {
          if (isFullScreen(editor)) setFullScreen(editor, false);
        },
        "Ctrl-Space": "autocomplete",
        "Ctrl-S": function(){
            quickSave();
        }
      },
      onChange: function(){
          if(editor_vars[id].changed == false){
              var selected_asset = j(".asset_item.selected_asset");
              selected_asset.html("<span class='star'>*</span>" + selected_asset.html());
              j(".editor_title").html("<span class='star'>*</span>" + j(".editor_title").html());
              editor_vars[id].changed = true;
          }
          changeUndoRedoColor(id);
      }
    });
    j(".CodeMirror").css("font-size", ((parseInt(font_size))/10).toString() + "em");

    var hlLine = editors[id].setLineClass(0, "activeLine");

    editors[id].setOption("theme", theme);

    if(ln == "false")
      editors[id].setOption("lineNumbers", false);

    CodeMirror.connect(window, "resize", function() {
      var showing = document.body.getElementsByClassName("CodeMirror-fullscreen")[0];
      if (!showing) return;
      showing.CodeMirror.getScrollerElement().style.height = winHeight() + "px";
    });
    //simple hint
    CodeMirror.commands.autocomplete = function(editor) {
      CodeMirror.simpleHint(editor, CodeMirror.javascriptHint);
    };

    j("#editor_autoformat").click(function(){
        if(isCurrentAsset()){
            editors[id].autoFormatRange({ch:0, line:0}, {ch:0, line:10000});
        }
    });

    j("#editor_quick_save").click(function(){
        quickSave();
    });
    j("#editor_save_all").click(function(){
        saveAll();
    });

    setFullScreen(editors[id], fullscreen == true);
    j("#full_screen_icon").click(function(){
        setFullScreen(editors[id], !isFullScreen(editors[id]));
        editors[id].focus();
    });
    j("#arrow_redo_icon").click(function(){
        if(isCurrentAsset()){
            editors[id].redo();
        }
    });
    j("#arrow_undo_icon").click(function(){
        if(isCurrentAsset()){
            editors[id].undo();
        }
    });

    function showEditorMessage(msg){
        j("#editor_footer #message").html(msg);
    }
    function isCurrentAsset(){
        return (j(".asset_item.selected_asset#asset_" + editor_vars[id].asset_id).length != 0)
    }
    function quickSave(){
        if (editor_vars[id].changed == true && isCurrentAsset()){
            saveAsset(id);
        } else {
            showEditorMessage("No changes were found!");
        }
    }
    function saveAll(){
        if (editor_vars[id].changed == true){
            saveAsset(id);
        }else {
            showEditorMessage("No changes were found!");
        }
    }
    function saveAsset(id){
        j.ajax({
            url: "/admin/stores/" + store + "/assets/" + editor_vars[id].asset_id,
            type:"put",
            data: {asset: {file_content: editors[id].getValue()}},
            dataType: "json",
            error: function(){
                showEditorMessage("Something went wrong!");
            },
            success: function(data) {
                showEditorMessage("Successfully saved!");
                j(".asset_item#asset_" + editor_vars[id].asset_id + " .star").remove();
                j(".editor_title .star").remove();
                editor_vars[id].changed = false;
                editors[id].clearHistory();
                j("#arrow_redo_icon").removeClass("arrow_redo_icon_active");
                j("#arrow_undo_icon").removeClass("arrow_undo_icon_active");
            }
        });
    }
    function isFullScreen(editor) {
      return /\bCodeMirror-fullscreen\b/.test(editor.getWrapperElement().className);
    }

    function setFullScreen(editor, full) {
        var wrap = editor.getWrapperElement()
        if (full) {
            scrollTo(0, 0);
            j("#ide_windows").addClass("fullscreen");
            var header_height = parseInt(j("#editor_header").css("height").replace("px", ""));
            var footer_height = parseInt(j("#editor_footer").css("height").replace("px", ""));
            j(".CodeMirror-scroll, #editor_right_menu").css("height", (winHeight()-header_height-footer_height) + "px");
            j("#full_screen_icon").addClass("fullscreen").attr("title", "Minimaze");
            wrap.className += " CodeMirror-fullscreen";
            document.documentElement.style.overflow = "hidden";
            fullscreen = true;
        } else {
            j("#ide_windows").removeClass("fullscreen");
            j(".CodeMirror-scroll, #editor_right_menu").css("height", "400px");
            j("#full_screen_icon").removeClass("fullscreen").attr("title", "Full screen");
            wrap.className = wrap.className.replace(" CodeMirror-fullscreen", "");
            document.documentElement.style.overflow = "";
            fullscreen = false;
        }
        editor.refresh();
    }
}