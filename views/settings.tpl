% include("header.tpl")
% include("banner.tpl")

<script>
    

    function settingsSubmit(event) {
        var musicInclude = $("#includeMusic").is(":checked") ? 'true' : 'false';

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

    function setSettings() {
        var includeMusic = settings.find(setting => setting.name === "includeMusic").value == "true";
        if (includeMusic)
            $("#includeMusic").prop('checked', true);
        else 
            $("#includeMusic").prop('checked', false);
    }

    $(document).ready(function() {
        $("#submitButton").click(settingsSubmit);
        if (settings.length != 0) {
            setSettings();
        }
        else {
            settings = get_settings();
            setSettings();
        }
    });
</script>
<div class="w3-container w3-bottombar w3-topbar w3-border-white w3-text-white">
    <p>Welcome to the settings page, more features coming soon</p>
    
    <p>UNFORTUNATELY, THIS FEATURE WILL NOT WORK IN PRODUCTION, WILL BE COMING SOON</p>

    <input type="checkbox" id="includeMusic" name="includeMusic" value="music" />
    <label for="includeMusic">Have background music</label>

    <br>
    <br>

    <button id="submitButton">Click me to Submit!</button>
    <br>
    <br>
</div>
% include("footer.tpl")