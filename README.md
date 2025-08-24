## Requirements

- docker
- [noVnc & websockify](https://www.notion.so/Conexi-n-con-la-m-quina-259967fe894180bb875bf2ad329badd4)

## Usefull commands

to build the image
`sudo docker build -t vnc_ubuntu .`

to run the container
`sudo docker run -dt --rm --name vnc_ubuntu -p 5901:5901 vnc_ubuntu`

to enter the running container
`sudo docker exec -ti vnc_ubuntu /bin/bash`

(inside the running container) to run the vnc server
`./start-vnc.sh`


to stream the grpahics over the browser
`websockify --web=/usr/share/novnc 6080 localhost:5901`
