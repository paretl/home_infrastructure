# Home Infrastructure

This repository contains the infrastructure deployed on my servers.

I have 2 servers:
- *server1*: 4 CPUs, 4 GB RAM, 500GB HDD
- *server2*: 2 CPUs, 4 GB RAM, 500GB HDD

I installed 2 Debian Desktop on it to simplify the configuration for the first setup.

## Access

I use the domain *louisparet.co* for my web applications. But I don't own this domain and I'll never want it.

I've configured my laptop to point this domain (and its subdomains) to my public IP address. It permits to access to my applications only from my laptop even if I'm not at home.
For this configuration I use *dnsmasq* with *NetworkManager* and I disabled *systemd-resolved*.

## Infrastructure

### Server 1

The server 1 is for web applications.

It contains:
- *Jenkins* for automated jobs.
- *Prometheus* to monitor servers.
- *AlertManager* to manage monitoring alerts.
- *Grafana* to visualize Prometheus metrics.
- *NodeExporter* to expose server system metrics.
- *cAdvisor* to expose docker system metrics.
- *Nginx Proxy* as a proxy to redirect HTTP requests.

The code is located in the directory *server1/*.

### Server 2

The server 2 is for agents and on-demand jobs.

It contains:
- *Jenkins agents* to run jobs launched by Jenkins.
- *Github Actions agents* to run jobs launched by Github.
- *NodeExporter* to expose server system metrics.

The code is located in the directory *server2/*.

### External services

- *Github* to store my code and for Github Actions.
- *Pushover* to receive monitoring alerts as a notification on my phone.

## Scripts

For my deployment scripts, I mainly use:
- *Docker* and *Docker Compose* to easily deploy my applications in Docker containers.

## Contributions

I don't expect any contributions on this repository as it is for a personal usage.
But feel free to use my code to deploy it on your servers.
I'll appreciate any feedbacks. You can use `Github Issues` to send me them.