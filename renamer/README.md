# renamer

*renamer* is a script to change either files and folder names in a directory by characters.

### How to use

With `-h` you could get the help:

```
$./renamer.sh -h
-s, --simulate	Simulate output
-a, --apply	    Apply rename
-h, --help	    Show this help and exit
```

Now we change the name for a set of files, to do it you need pass the name of a csv file with the next format.

```
old,new
Rick.and.Morty.S01E01.720p.HDTV.x264.mkv,Rick and Morty S01E01 720p HDTV x264 mkv
Rick.and.Morty.S01E02.720p.HDTV.x264.mkv,Rick and Morty S01E02 720p HDTV x264 mkv
Rick.and.Morty.S01E03.720p.HDTV.x264.mkv,Rick and Morty S01E03 720p HDTV x264 mkv
```


It's possible to simulate the rename results using `-s` as:
```
$./renamer.sh -s input_file.csv
Rick.and.Morty.S01E01.720p.HDTV.x264.mkv  ->  Rick and Morty S01E01 720p HDTV x264 mkv
Rick.and.Morty.S01E02.720p.HDTV.x264.mkv  ->  Rick and Morty S01E02 720p HDTV x264 mkv
Rick.and.Morty.S01E03.720p.HDTV.x264.mkv  ->  Rick and Morty S01E03 720p HDTV x264 mkv
```

To apply the renames you have to use `-a`.
