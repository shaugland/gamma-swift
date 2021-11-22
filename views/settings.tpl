% include("header.tpl")
% include("banner.tpl")

<script>
    function settingsSubmit(event) {
        var musicInclude = $("#includeMusic").is(":checked") ? 1 : 0;

        settings = {
            'name': 'includeMusic',
            'value': musicInclude
        };

        $.ajax({url:"api/settings", type:"POST", 
          data:JSON.stringify(settings), 
          contentType:"application/json; charset=utf-8",
          success:settingsSaved});
    }

    function settingsSaved() {
        alert("your settings have been successfully saved");
    }

    $(document).ready(function() {
        $("#submitButton").click(settingsSubmit);
        
        % print([element for element in tasks if element['name'] == 'includeMusic'][0])
        % if [element for element in tasks if element['name'] == 'includeMusic'][0]['value'] == True:
            $("#includeMusic").prop('checked', true);
        % else:
            $("#includeMusic").prop('checked', false);
        %end
    });
</script>

<p>Welcome to the settings page, more features coming soon</p>

<input type="checkbox" id="includeMusic" name="includeMusic" value="music" />
<label for="includeMusic">Have background music</label>

<button id="submitButton">Click me to Submit!</button>
<br />
% include("footer.tpl")