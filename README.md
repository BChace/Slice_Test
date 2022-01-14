# Slice_Test

For the first part I tried to get it work on windows docker with trying to use an overlay network and labels to force them into localhost.
But being windows it really didn't like that, I reached out to verify/ make sure it was suppose to be in a linux host environment. Then spun up the ubuntu windows sandbox and added `network_mode: host` to the docker compose file and tested it. App was reachable from local host and curl could poll both /sres and /health.

The second part I started by creating a shell script `SliceHealth.sh` to poll `/health` every 10 seconds and `exit 1` if it didn't return a `200`. I also used sed, grep, and awk to format the curl output and dump it into `/tmp/log.txt`. I then added a if then that waited until the row count got to 6 and then outputed the average, min, and max values of requestLatency, dbLatency, and cacheLatency then cleared the log file so that it didn't balloon in size. 

After that I created the sidecar container by adding this to the `docker-compose.yml` file 
```
sidecar:
    image: alpine:latest
    volumes:
      - ./var/run/docker.sock:/var/run/docker.sock 
      - ./var/run/SliceHealth.sh:/var/run/SliceHealth.sh
    network_mode: host
    depends_on: 
     - nginx    
    command: > 
        sh -c "apk --no-cache add curl && /var/run/SliceHealth.sh"
```
