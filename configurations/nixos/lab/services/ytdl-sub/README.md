# ytdl-sub

## Workflow

The metadata generation from YouTube is sometimes messed up. I suspect it's due
to the fact that some videos are music videos, so the metadata tagging gets
messed up. Sometimes, it just works out perfectly (see 224 Kiss of Life).

We can use an application like `picard` to manually cluster and retag the music.
This seems to work _really_ well, but there are a few straggler cases.

I think the best course of action forward is to define which playlists in the
channel we want.

> Another workaround is to look for "X - topic" YouTube channels which avoid
> music avoids altogether
