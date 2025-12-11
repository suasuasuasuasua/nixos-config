{
  "__preset__" = {
    overrides = {
      # WARNING: for some reason can't use a root path like
      # /zshare/media/
      # Will need to investigate...but this is a nice automation. Cut
      # and paste to the samba share is fine for now probably
      music_directory = "music";
      music_video_directory = "music_videos";

      # Filter out remixes, covers, live performances, and other non-original content
      # This uses yt-dlp's match_filter syntax to reject videos based on title patterns
      # The filter rejects videos with titles containing these keywords (case-insensitive)
      ytdl_options = {
        match_filter = "!is_live & title!*='(?i).*(remix|cover|live|acoustic|instrumental|piano|lyric|lyrics|karaoke|reaction|tutorial|dance practice|behind|making|vlog|vlive|eng sub|legendado).*'";
      };
    };
  };
  "YouTube Releases" = {
    "= Indie" = {
      "Billie Eilish" = "https://www.youtube.com/channel/UCERrDZ8oN0U_n9MphMKERcg";
      "Laufey" = "https://www.youtube.com/channel/UCJtROTPxo3qnEzww8JyDxuA";
      "NIKI" = "https://www.youtube.com/channel/UCFeCzD2Fqr3jlMcGTt0Jnlg";
      "The Marias" = "https://www.youtube.com/channel/UCVV5M4OEFsKnB9HBhwOhHbA";
    };
    "= K-Pop" = {
      "aespa" = "https://www.youtube.com/channel/UCEdZAdnnKqbaHOlv8nM6OtA";
      "BABYMONSTER" = "https://www.youtube.com/channel/UC47Wz6S14mj_6Jy-T59m6IQ";
      "ITZY" = "https://www.youtube.com/channel/UCTP45_DE3fMLujU8sZ-MBzw";
      "IVE" = "https://www.youtube.com/channel/UCTP45_DE3fMLujU8sZ-MBzw";
      "JENNIE" = "https://www.youtube.com/channel/UCAl7xQ6q0PEgZMQD7zr4AKQ";
      "KISS OF LIFE" = "https://www.youtube.com/channel/UCy_chGIsdShihFYBoXZyTdg";
      "LE SSERAFIM" = "https://www.youtube.com/channel/UC-clMkTZa7k-FxmNgMjoCgQ";
      "NewJeans" = "https://www.youtube.com/channel/UCxOqS3cYg4FaHbobICo7nFQ";
      "ROSÉ" = "https://www.youtube.com/channel/UCbpXC82cTLngSiZrysAaE-w";
      "XG" = "https://www.youtube.com/channel/UCafINmoeAbZbK5M4dtQzBww";
    };
    "= Instrumental" = {
      "Justin Hurwitz" = "https://www.youtube.com/channel/UC2Qhpr5OGrn9skA6N5LBPGQ";
      "Valentina Lisitsa" = "https://www.youtube.com/channel/UC54WzoB6QbFsKTFcWK6em4Q";
    };
  };
}
