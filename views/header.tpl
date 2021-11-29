<!DOCTYPE html>
<html lang="en">
<head>
  <title>SWIFT Taskbook</title>
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
            type: "POST",
            contentType: "application/json; charset=utf-8",
            success: function(res) {
              settings = res.settings;
            }
          });
  </script>
</head>
<body>

<script>
  function get_settings() {
    $.ajax({
              url: "api/settings", 
              type: "GET",
              contentType: "application/json; charset=utf-8",
              success: function(res) {
                settings = res.settings;
              }
          });

    return settings;
  }
</script>