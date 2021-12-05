% include("header.tpl")
% include("banner.tpl")

<style>
  .save_edit, .undo_edit, .move_task, .description, .edit_task, .delete_task, .time {
    cursor: pointer;
  }
  .completed {text-decoration: line-through;}
  .description {padding-left:8px; word-wrap: break-word;}
  

</style>

<!--<div class="w3-sidebar w3-blue" style="top: 125px;"></div>-->

<div class="w3-row">
  <div class="w3-col l2 m2 s4" style="">
    <p> </p>
  </div>
  <div class="w3-col l8 m8 s8" style="">
    <div class="w3-row w3-round w3-container w3-topbar w3-bottombar w3-leftbar w3-rightbar w3-border-blue w3-margin-left w3-margin-right w3-margin-top">
      <div class="w3-row w3-center w3-xxlarge">
        <h1><b>Add a Task...</b></h1>
      </div>
      <div id="task-list-editor" class="w3-table">
      </div>
    </div>
    <div class="w3-row w3-container w3-topbar w3-bottombar w3-leftbar w3-rightbar w3-border-white" ondrop="drop_today(event)" ondragover="allow_drop(event)">
      <div class="w3-row w3-xxlarge w3-bottombar w3-border-black w3-margin-bottom">
        <h1><i>Today</i></h1>
      </div>
      <table id="task-list-today" class="w3-table">
      </table>
      <div class="w3-row w3-bottombar w3-border-black w3-margin-bottom w3-margin-top"></div>
    </div>
    <div class="w3-row w3-container w3-topbar w3-bottombar w3-leftbar w3-rightbar w3-border-white" ondrop="drop_tomorrow(event)" ondragover="allow_drop(event)">
      <div class="w3-row w3-xxlarge w3-bottombar w3-border-black w3-margin-bottom">
        <h1><i>Tomorrow</i></h1>
      </div>
      <table  id="task-list-tomorrow" class="w3-table">
      </table>
      <div class="w3-row w3-bottombar w3-border-black w3-margin-bottom w3-margin-top"></div>
    </div>
    <div class="w3-row w3-container w3-topbar w3-bottombar w3-leftbar w3-rightbar w3-border-white" ondrop="drop_someday(event)" ondragover="allow_drop(event)">
      <div class="w3-row w3-xxlarge w3-bottombar w3-border-black w3-margin-bottom">
        <h1><i>Someday</i></h1>
      </div>
      <table  id="task-list-someday" class="w3-table">
      </table>
      <div class="w3-row w3-bottombar w3-border-black w3-margin-bottom w3-margin-top"></div>
    </div>
  </div>
  <div class="w3-col l2 m2 w3-hide-small" style=""> 
  <p> </p>
  </div>
</div>


<input id="current_input" hidden value=""/> 
<script>



// Change from 24hr to 12hr
// Takes time in the form of 00:00

function change_time(time){
  if(time != null && time != ''){
    var suffix = (time[0] + time[1]) >= 12 ? "PM" : "AM";

    // This is a weird way to do this. Fix if you have a better idea
    newTime = ((parseInt(String(time[0] + time[1])) + 11) % 12 + 1) + time.slice(2,5) + ' ' + suffix;
    return newTime;
  }
  return time;
}

/* DRAG CALLS */
function drag(ev) {
  ev.dataTransfer.setData("text", ev.target.id);
}

function allow_drop(ev) {
  ev.preventDefault();
}

function drop_tomorrow(ev) {
  ev.preventDefault();
  var data = ev.dataTransfer.getData("text");
  var element = document.getElementById(data);

  var id = element.id.split('description-')[1];

  api_update_task({'id':id, 'list':'tomorrow'},
                  function(result) { 
                    console.log(result);
                    get_current_tasks();
                  } );
}

function drop_today(ev) {
  ev.preventDefault();
  var data = ev.dataTransfer.getData("text");
  var element = document.getElementById(data);

  var id = element.id.split('description-')[1];

  api_update_task({'id':id, 'list':'today'},
                  function(result) { 
                    console.log(result);
                    get_current_tasks();
                  } );
}

function drop_someday(ev) {
  ev.preventDefault();
  var data = ev.dataTransfer.getData("text");
  var element = document.getElementById(data);

  var id = element.id.split('description-')[1];

  api_update_task({'id':id, 'list':'someday'},
                  function(result) { 
                    console.log(result);
                    get_current_tasks();
                  } );
}

/* API CALLS */

function api_get_tasks(success_function) {
  $.ajax({url:"api/tasks", type:"GET", 
          success:success_function});
}

function api_create_task(task, success_function) {
  console.log("creating task with:", task)
  $.ajax({url:"api/tasks", type:"POST", 
          data:JSON.stringify(task), 
          contentType:"application/json; charset=utf-8",
          success:success_function});
}

function api_update_task(task, success_function) {
  console.log("updating task with:", task)
  task.id = parseInt(task.id)
  $.ajax({url:"api/tasks", type:"PUT", 
          data:JSON.stringify(task), 
          contentType:"application/json; charset=utf-8",
          success:success_function});
}

function api_delete_task(task, success_function) {
  console.log("deleting task with:", task)
  task.id = parseInt(task.id)
  $.ajax({url:"api/tasks", type:"DELETE", 
          data:JSON.stringify(task), 
          contentType:"application/json; charset=utf-8",
          success:success_function});
}

/* KEYPRESS MONITOR */

function input_keypress(event) {
  if (event.target.id != "current_input") {
    $("#current_input").val(event.target.id)
  }
  id = event.target.id.replace("input-","");
  $("#filler-"+id).prop('hidden', true);
  $("#save_edit-"+id).prop('hidden', false);
  $("#undo_edit-"+id).prop('hidden', false);
}

/* EVENT HANDLERS */

function move_task(event) {
  if ($("#current_input").val() != "") { return }
  console.log("move item", event.target.id )
  id = event.target.id.replace("move_task-","");
  if (id.includes("move_task2")) id = event.target.id.replace("move_task2-","");
  target_list = event.target.className.search("today") > 0 || event.target.className.search("someday") > 0 ? "tomorrow" : "today";
  if (event.target.className.search("forward") > 0)
    target_list = "someday";
  api_update_task({'id':id, 'list':target_list},
                  function(result) { 
                    console.log(result);
                    get_current_tasks();
                  } );
}

function complete_task(event) {
  if ($("#current_input").val() != "") { return }
  console.log("complete item", event.target.id )

  // Allows ability to click on time to complete
  if(event.target.id.includes("description-"))
    id = event.target.id.replace("description-","");
  else if(event.target.id.includes("time-"))
    id = event.target.id.replace("time-","");

  completed = event.target.className.search("completed") > 0;
  console.log("updating :",{'id':id, 'completed':completed==false})
  api_update_task({'id':id, 'completed':completed==false}, 
                  function(result) { 
                    console.log(result);
                    get_current_tasks();
                  } );
}

function edit_task(event) {
  if ($("#current_input").val() != "") { return }
  console.log("edit item", event.target.id)
  id = event.target.id.replace("edit_task-","");
  // move the text to the input editor
  $("#input-"+id).val($("#description-"+id).text());
  $("#tagInput-"+id).val($("#tag-"+id).text());
  $("#tagColor-"+id).val($())

  // hide the text display
  $("#move_task-"+id).prop('hidden', true);
  $("#move_task2-"+id).prop('hidden', true);
  $("#description-"+id).prop('hidden', true);
  $(".tag-"+id).addClass("w3-hide");
  $("#edit_task-"+id).prop('hidden', true);
  $("#delete_task-"+id).prop('hidden', true);
  $("#time-"+id).prop('hidden', true);
  $("#line-"+id).prop('hidden', true);
  
  // show the editor
  $("#editor-"+id).prop('hidden', false);
  $("#save_edit-"+id).prop('hidden', false);
  $("#undo_edit-"+id).prop('hidden', false);
  // set the editing flag
  $("#current_input").val(event.target.id)
  // set the time TODO: fix this pleeease
  //$("#timeInput-" + id).val($("#time-"+id).val())
  //$("#time-"+id).hide();
}

function save_edit(event) {
  console.log("save item", event.target.id)
  id = event.target.id.replace("save_edit-","");
  console.log("desc to save = ",$("#input-" + id).val())
  if (id != "editor") {
    api_update_task({'id':id, description:$("#input-" + id).val(), completeBy:$("#timeInput-" + id).val()
                          , tag:$("#tagInput-" + id).val(), tagColor:$("#tagColor-" + id).val(), taskColor:$("#taskColor-" + id).val()},
                    function(result) { 
                      console.log(result);
                      get_current_tasks();
                      $("#current_input").val("")
                    } );
  } else {
    api_create_task({description:$("#input-" + id).val(), list:$("#list-" + id).val(), completeBy:$("#timeInput-" + id).val()
                            , tag:$("#tagInput-" + id).val(), tagColor:$("#tagColor-" + id).val(), taskColor:$("#taskColor-" + id).val()},
                    function(result) { 
                      console.log(result);
                      get_current_tasks();
                      $("#current_input").val("")
                    } );
  }
}

function undo_edit(event) {
  id = event.target.id.replace("undo_edit-","")
  console.log("undo",[id])
  $("#input-" + id).val("");
  $("#tagInput-" +id).val("");
  $("#tagColor-" +id).val("");
  $("#save_edit-"+id).prop('hidden', true);
  $("#undo_edit-"+id).prop('hidden', true);
  $("#filler-"+id).prop('hidden', false);
  if (id != "editor") {
    // hide the editor
    $("#editor-"+id).prop('hidden', true);

    // show the text display
    $("#move_task-"+id).prop('hidden', false);
    $("#move_task2-"+id).prop('hidden', false);
    $("#description-"+id).prop('hidden', false);
    $(".tag-"+id).removeClass("w3-hide");
    
    $("#edit_task-"+id).prop('hidden', false);
    $("#delete_task-"+id).prop('hidden', false);
    $("#time-"+id).prop('hidden', false);
    $("#line-"+id).prop('hidden', false);
  }
  // set the editing flag
  $("#current_input").val("")
}

function delete_task(event) {
  if ($("#current_input").val() != "") { return }
  console.log("delete item", event.target.id )
  id = event.target.id.replace("delete_task-","");
  api_delete_task({'id':id},
                  function(result) { 
                    console.log(result);
                    get_current_tasks();
                  } );
}

function display_task(x) {

  arrow = (x.list == "today") ? "arrow_downward" : "arrow_upward";
  completed = x.completed ? " completed" : "";

    // separate tags into array
  var tagHtml = '';
  if (x.tag)
    x.tag.split(",").forEach(tag => {
      tagHtml += '<span class="description tag-'+x.id+' ' + completed + ' w3-tag '+x.tagColor+'" >'  + tag  + '</span>         ';
    });


  if ((x.id == "editor")) {
    t = '<tr id="task-'+x.id+'" class="task">' +
        '  <td><span id="editor-'+x.id+'">' + 
    '        <select id="list-'+x.id+'" style="width:105px"> '+
    '           <option value="today">Today</option>'+
    '           <option value="tomorrow">Tomorrow</option>'+
    '           <option value="someday">Someday</option>'+
    '         </select>'+
    '        <input id="input-'+x.id+'" style="height:25px; display:inline-block; width:30%;" class="w3-input w3-border w3-round" '+ 
    '          type="text" autofocus placeholder="Add an item..."/>'+
    '        <input id="timeInput-'+x.id+'" style="height:25px; display:inline-block; width:150px;" class="w3-input w3-round w3-border" '+ 
    '          type="time"/>'+
    '        <input id="tagInput-'+x.id+'" style="height:25px; display:inline-block; width:200px;" class="w3-input w3-round w3-border" '+ 
    '          type="text" autofocus placeholder="Tag, separate by ,"/>'+
    '         <label for="task">Task Color:</label> '+
    '           <input type="color" id="taskColor-'+x.id+'"value="#ffffff" '+
    '                     name="task" style="height:23px; display:inline-block; width:23px; margin-right:1%; border-style:none; background-color:white;">'+
    '         <label for="tagColor">Tag Color:</label> '+
    '           <select type="text" name="tagColor" id="tagColor-'+x.id+'" style="width:80px"> '+
    '               <option class = "w3-tag w3-white" value="w3-transparent w3-text-black">White</option>'+
    '               <option class = "w3-tag w3-black" value="w3-black">Black</option>'+
    '               <option class = "w3-tag w3-red" value="w3-red">Red</option>'+
    '               <option class = "w3-tag w3-orange" value="w3-orange">Orange</option>'+
    '               <option class = "w3-tag w3-yellow" value="w3-yellow">Yellow</option>'+
    '               <option class = "w3-tag w3-green" value="w3-green">Green</option>'+
    '               <option class = "w3-tag w3-blue" value="w3-blue">Blue</option>'+
    '               <option class = "w3-tag w3-indigo" value="w3-indigo">Indigo</option>'+
    '               <option class = "w3-tag w3-purple" value="w3-purple">Violet</option>'+
    '           </select>'+
    '      </span>' +  
    '  </td>' +
        '  <td style="width:72px">' +
        '    <span id="filler-'+x.id+'" class="material-icons">more_horiz</span>' + 
        '    <span id="save_edit-'+x.id+'" hidden class="save_edit material-icons">done</span>' + 
        '    <span id="undo_edit-'+x.id+'" hidden class="undo_edit material-icons">cancel</span>' +
        '  </td>' +
        '</tr>';
  } else {
    t = '<tr id="task-'+x.id+'" class="task">' + 

        '  <td style="width:20px"><span id="move_task-'+x.id+'" class="move_task '+x.list+' material-icons" style="width:20px">' + arrow + '</span>' +
              (x.list == "tomorrow" ? '<br><span id="move_task2-'+x.id+'" class="move_task forward'+x.list+' material-icons">arrow_downward</span>' : '') + '</td>' +
        '  <td style="max-width:0px;"><span id="description-'+x.id+'" class="description' + completed + '" style="background-color:'+x.taskColor+'; padding:5px; border-radius: 3px">' + x.description + '</span>' + 
        '  <span id="line-'+x.id+'">' + (x.completeBy ? ' - ' : '') +'</span>'  +
        '      <span id="time-' + x.id + '" class="description '+ completed + '" style="padding-left:0px;"' + '">' + (x.completeBy ? change_time(x.completeBy) : '') + '</span>' + 
        '      <span id="editor-'+x.id+'" hidden>' + 
        '        <input id="input-'+x.id+'" style="height:25px; display:inline-block; width:30%;" class="w3-input w3-animate-input w3-border" type="text" autofocus/>' +
        '        <input id="timeInput-'+x.id+'" style="height:25px; display:inline-block; width:150px;" class="w3-input w3-border" '+ 
        '          type="time" value="' + (x.completeBy ?? '00:00') + '"/>'+
        '        <input id="tagInput-'+x.id+'" style="height:25px; display:inline-block; width:200px" class="w3-input w3-border" type="text" autofocus placeholder="Tag, separate by ,"/>' +
        '         <label for="task">Task</label> '+
        '           <input type="color" id="taskColor-'+x.id+'"value="'+x.taskColor+'" name="task" style="height:23px; '+
        '                       display:inline-block; width:23px; margin-right:1%; border-style:none; background-color:white;">'+
        '         <label for="tagColor">Tag</label> '+
        '           <select name="tagColor" id="tagColor-'+x.id+'" style="width:80px"> '+
        '               <option class = "w3-tag w3-white" value="w3-transparent w3-text-black">White</option>'+
        '               <option class = "w3-tag w3-black" value="w3-black">Black</option>'+
        '               <option class = "w3-tag w3-red" value="w3-red">Red</option>'+
        '               <option class = "w3-tag w3-orange" value="w3-orange">Orange</option>'+
        '               <option class = "w3-tag w3-yellow" value="w3-yellow">Yellow</option>'+
        '               <option class = "w3-tag w3-green" value="w3-green">Green</option>'+
        '               <option class = "w3-tag w3-blue" value="w3-blue">Blue</option>'+
        '               <option class = "w3-tag w3-indigo" value="w3-indigo">Indigo</option>'+
        '               <option class = "w3-tag w3-purple" value="w3-purple">Violet</option>'+
        '           </select>'+
        '      </span>' + 
        '      <br><span id="tag-'+x.id+'" class="description tag-'+x.id+' ' + completed + ' w3-tag w3-white" style="display: none;">'  + x.tag  + '</span>' + 
                tagHtml +
        '  </td>' +
          

        '  <td style="width:72px" class="w3-right-align">' +
        '    <span id="edit_task-'+x.id+'" class="edit_task '+x.list+' material-icons">edit</span>' +
        '    <span id="delete_task-'+x.id+'" class="delete_task material-icons">delete</span>' +
        '    <span id="save_edit-'+x.id+'" hidden class="save_edit material-icons">done</span>' + 
        '    <span id="undo_edit-'+x.id+'" hidden class="undo_edit material-icons">cancel</span>' +
        '  </td>' +
        '</tr>';
  }
  $("#task-list-" + x.list).append(t);
  $("#current_input").val("")
}

function get_current_tasks() {
  // remove the old tasks
  $(".task").remove();
  // display the new task editor
  //display_task({id:"today", list:"today"})
  //display_task({id:"tomorrow", list:"tomorrow"})
  //display_task({id:"someday", list:"someday"})
  display_task({id:"editor", list:"editor"})


  // display the tasks
  api_get_tasks(function(result){
    for (const task of result.tasks) {
      display_task(task);
    }
    // wire the response events 
    $(".move_task").click(move_task);
    $(".description").click(complete_task);
    $(".edit_task").click(edit_task);
    $(".save_edit").click(save_edit);
    $(".undo_edit").click(undo_edit);
    $(".delete_task").click(delete_task);
    // set all inputs to set flag
    $("input").keypress(input_keypress);

  });
}

$(document).ready(function() {
  get_current_tasks()
});

</script>
% include("footer.tpl")
