<footer class="w3-container w3-bottombar  w3-border-white w3-black w3-center">
    <p>To contact us, please email <a href="mailto:taskbookgamma@protonmail.com">taskbookgamma@protonmail.com</a></p>
    <br>
    <audio controls id="player" loop>
        <source src="/static/City Ambience.mp3" type="audio/mp3">
    </audio>
    <br>

    <script>
        $(document).ready(function () {
            if (settings.find(setting => setting.name === 'includeMusic').value === 'false')
                    $("#player").hide();
        });
    </script>
</footer>
</body>
</html>