camera-stats
============

![map.html](https://raw.githubusercontent.com/ryanmjacobs/camera-stats/master/map.html.png)

Dependencies
------------
Go ahead and grab R from your package manager. Typically you can run:
```
$ sudo apt-get install R
```
Then install packrat with the R command `install.packages("packrat")`,
```
$ sudo R
> install.packages("packrat")
> quit()
Save workspace image? [y/n/c]: n
```

Grab some data!
---------------
We're gonna need some data to plot :smile:
```
$ ./collect_data.sh /path/to/some/images
```

Plot the points!
----------------
Once we have collected some geolocation data, we can plot them on a map!
```
$ ./gen_map.r
```
