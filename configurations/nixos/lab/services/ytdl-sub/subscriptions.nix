let
  # Keywords to filter from video titles (case-insensitive)
  # Note: Keywords should not contain regex special characters like ., *, ?, +, etc.
  # If you need to filter patterns with special characters, escape them properly.
  filteredKeywords = [
    "remix"
    "cover"
    "live"
    "acoustic"
    "instrumental"
    "piano"
    "lyric"
    "lyrics"
    "karaoke"
    "reaction"
    "tutorial"
    "dance practice"
    "behind"
    "making"
    "vlog"
    "vlive"
    "eng sub"
    "legendado"
  ];

  # Build the match_filter string for yt-dlp
  # Rejects videos whose titles contain any of the keywords
  matchFilterString = 
    "!is_live & title!*='(?i).*(${builtins.concatStringsSep "|" filteredKeywords}).*'";
in
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
      # Note: This applies globally, including to the "Instrumental" category below
      ytdl_options = {
        match_filter = matchFilterString;
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
