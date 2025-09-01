# Simulation Container
This repo has the objective to allow other users to control a container (server) with gazebo. 

In this way multiple persons can work asynchronously in a simulation.

## Key features
- A ubuntu machine with graphic service easily sharable with your collaborators.
- Copy and paste between your local machine and the server
- Persistency on the `workspace` directory 

## Requirements

- docker


## Running
1. Run `sudo docker compose up -d --build`. The noVNC server will be running on port 6080.
2. Use a tool to tunnel your port to the internet (i.e. VSCode Ports). Share the link with your collaborators.
3. Open the noVNC and authenticate with your password.

## Tear Down
`sudo docker compose down`

## Saving your changes
Plase note that the docker-compose file will create a docker volume called `main_volume`.
All the files that you want to save after putting down the container should be saved in the default directory: `workspace` 
⚠️ Everything outside that folder will dissapear when the container stops
