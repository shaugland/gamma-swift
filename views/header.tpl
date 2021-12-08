<!DOCTYPE html>
<html lang="en">
<head>
  <title>Taskbook Gamma</title>
  <link rel="icon" type="image/x-icon" href="/static/favicon4.ico">
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet"/>
  <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
  <style>
    tr:nth-child(even) {
      background-color: #f2f2f2;
    }

  </style>
  <script>
    var settings = [];
    $.ajax({
            async: false,
            url: "api/settings/get", 
            type: "GET",
            contentType: "application/json; charset=utf-8",
            success: function(res) {
              settings = res.settings;
            }
          });

    $.ajax({
      async: false,
      url: "api/tasks",
      type: "GET",
      contentType: "application/json; charset=utf-8",
      success: (res) => {
        settings = res.testingSettings;
      }
    })
  </script>
</head>
<body class="w3-light-grey w3-leftbar w3-rightbar w3-border-white" style="background-image: url('https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fwallpapercave.com%2Fwp%2Ff0VfAbM.jpg&f=1&nofb=1');">

<script>
  function get_settings() {
    $.ajax({
              url: "api/settings/get", 
              type: "GET",
              contentType: "application/json; charset=utf-8",
              success: function(res) {
                settings = res.settings;
              }
          });

    return settings;
  }
</script>