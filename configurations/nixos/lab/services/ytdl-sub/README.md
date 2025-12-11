# ytdl-sub

## Filtering Strategy

The configuration now includes filtering to download only original songs and exclude non-original content like:
- Remixes
- Covers
- Live performances
- Acoustic versions
- Instrumental versions
- Piano versions
- Lyric videos
- Karaoke versions
- Reactions
- Tutorials
- Dance practices
- Behind-the-scenes content
- Making-of videos
- Vlogs
- Videos with subtitles markers (eng sub, legendado)

This is implemented using yt-dlp's `match_filter` option in the `__preset__` overrides. The filter rejects videos whose titles match any of the above patterns (case-insensitive) and also excludes live streams.

**Note:** The "instrumental" keyword filter applies to all categories in your subscriptions, including the "= Instrumental" category. If this causes issues with downloading instrumental music, you may need to either:
1. Remove "instrumental" from the filter pattern, or
2. Create a separate preset for the Instrumental category without that keyword

### How the Filter Works

The filter is implemented using a clean, maintainable structure:
1. A list of keywords (`filteredKeywords`) defines all terms to filter out
2. The list is programmatically converted into a yt-dlp match_filter expression
3. The filter uses the syntax: `!is_live & title!*='(?i).*(pattern1|pattern2).*'`

Components explained:
- `!is_live` - Excludes live streams
- `title!*=` - Rejects if title matches the pattern (note: no space before `!*=`)
- `(?i)` - Case-insensitive matching
- `.*` - Matches any characters before/after the keywords
- Patterns are separated by `|` (OR operator)

**To add or remove filtered keywords:** Simply edit the `filteredKeywords` list at the top of `subscriptions.nix`.

### Alternative Approach: Using Playlists

If you find that title filtering is too aggressive or misses some content, consider switching to playlist-based subscriptions instead of entire channels. You can:
1. Find the specific "Releases" or "Official" playlist for each artist
2. Replace the channel URL with the playlist URL
3. This ensures you only get official releases without remixes/covers that might be uploaded to the same channel

Example:
```nix
"Artist Name" = "https://www.youtube.com/playlist?list=PLAYLIST_ID_HERE";
```

## Workflow

The metadata generation from YouTube is sometimes messed up. I suspect it's due
to the fact that some videos are music videos, so the metadata tagging gets
messed up. Sometimes, it just works out perfectly (see 224 Kiss of Life).

We can use an application like `picard` to manually cluster and retag the music.
This seems to work _really_ well, but there are a few straggler cases.

I think the best course of action forward is to define which playlists in the
channel we want.

> Another workaround is to look for "X - topic" YouTube channels which avoid
> music videos altogether and focus on official releases
