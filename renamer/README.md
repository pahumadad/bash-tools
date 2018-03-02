# renamer

--

*renamer* is a script to change either files and folder names in a directory by characters.

### How to use

With `-h` you could get the help:

```sh
$ bash renamer.sh -h

[-a | --apply]        		to apply the rename. By default will only simulate and show the results
[-s1 | --str1 STRING1]    	STRING1 is the string to look for in files names to be replaced
[-s2 | --str2 STRING2]    	STRING2 is the string to replace in the files names
[-f | --file FILE]    		absolute path to the CSV file with STRING1 and STRING2 rows

```

Now we change the name for a set of files, to do it you need pass the name of a csv file with the next format.

```
old,new
Rick.and.Morty.S01E01.720p.HDTV.x264.mkv,Rick and Morty S01E01 720p HDTV x264 mkv
Rick.and.Morty.S01E02.720p.HDTV.x264.mkv,Rick and Morty S01E02 720p HDTV x264 mkv
Rick.and.Morty.S01E03.720p.HDTV.x264.mkv,Rick and Morty S01E03 720p HDTV x264 mkv
```


It's possible to simulate the rename results using:

```sh
$ bash renamer.sh -f input_file.csv

Rick.and.Morty.S01E01.720p.HDTV.x264.mkv  ->  Rick and Morty S01E01 720p HDTV x264 mkv
Rick.and.Morty.S01E02.720p.HDTV.x264.mkv  ->  Rick and Morty S01E02 720p HDTV x264 mkv
Rick.and.Morty.S01E03.720p.HDTV.x264.mkv  ->  Rick and Morty S01E03 720p HDTV x264 mkv
```

To apply the renames you have to use `-a`.
