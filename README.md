# Simulation Container
This repo has the objective to allow other users to control a container (server) with gazebo. 

In this way multiple persons can work asynchronously in a simulation.

## Requirements

- docker


## Build Up
`sudo docker compose up -d --build`

## Tear Down
`sudo docker compose down`

## Saving your changes
Plase note that the docker-compose file will create a docker volume called `main_volume`.
All the files that you want to save after putting down the container should be saved in the default directory: `workspace` 
⚠️ Everything outside that folder will dissapear when the container stops
