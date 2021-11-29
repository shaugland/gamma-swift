
<audio controls id="player" loop>
    <source src="/static/City Ambience.mp3" type="audio/mp3">
</audio>

<script>
    $(document).ready(function () {
        if (settings.find(setting => setting.name === 'includeMusic').value === 'false')
                $("#player").hide();
    });
</script>
</body>
</html>