# Deploying a Dockerized Web Application on AWS EC2

This repository demonstrates how to deploy a web application using Docker on an AWS EC2 instance and connect to the server using VS Code Remote SSH.

The goal is to provision an EC2 instance, install Docker automatically using user-data, deploy a containerised application, and access it via the browser.

---

# Architecture Overview

Components used in this deployment:

* Amazon Web Services EC2 instance
* Docker for containerized application deployment
* Visual Studio Code with Remote SSH extension
* Linux-based EC2 server (Ubuntu recommended)

The application runs inside a Docker container and is accessible through the EC2 public IP address on port 3000.

---

# Prerequisites

Before starting, ensure you have:

* An AWS account
* An EC2 instance running (Ubuntu recommended)
* A configured Security Group allowing:

```
SSH (22)
HTTP (optional)
Custom TCP: 3000
```

* Installed locally:

```
Docker (optional if deploying locally)
Visual Studio Code
VS Code Remote SSH Extension
```

---

# Step 1 — Launch EC2 Instance

1. Log into AWS Console.
2. Navigate to EC2 Dashboard.
3. Click Launch Instance.
4. Choose an Ubuntu Server AMI.
5. Select instance type (e.g., `t2.micro` or `t3.micro`).
6. Create or select an existing Key Pair.
7. Configure Security Group rules:

```
SSH: 22
Custom TCP: 3000
```

8. Launch the instance.

---

# Step 2 — Copy the Key Pair Path

Locate the downloaded `.pem` key pair.

Example:

```
my-keypair.pem
```

Copy the absolute path of the file.

Depending on your OS:

### Windows

Right-click the key file → Copy as Path

### macOS / Linux

```
pwd
```

or drag the file into the terminal.

---

# Step 3 — Set Correct Key Permissions

Run the following command in the terminal:

```
chmod 400 my-keypair.pem
```

This ensures the key is secure and usable for SSH authentication.

---

# Step 4 — Connect to EC2 Using VS Code

Open Visual Studio Code.

Install the extension:

```
Remote - SSH
```

Then connect:

1. Press Ctrl + Shift + P
2. Select:

```
Remote-SSH: Connect to Host
```

Use the command format:

```
ssh -i /path/to/keypair.pem ubuntu@<EC2_PUBLIC_IP>
```

Example:

```
ssh -i ~/keys/my-keypair.pem ubuntu@3.120.45.88
```

If prompted:

```
Select Linux
```

Click Connect.

---

# Step 5 — Open the Instance Folder

Once connected:

1. Click Open Folder
2. Select the home directory
3. Click OK

You are now connected to the EC2 instance via VS Code.

---

# Step 6 — Confirm Docker Installation

Docker should already be installed via the EC2 user-data script.

Verify installation:

```
docker --version
```

You should see output similar to:

```
Docker version 25.x.x
```

Also confirm the service is running:

```
docker ps
```

---

# Step 7 — Run the Application Container

Run the Docker container:

```
docker run -d -p 3000:3000 <image-name>
```

Check running containers:

```
docker ps
```

Example output:

```
CONTAINER ID   IMAGE         PORTS
abcd1234       my-node-app   0.0.0.0:3000->3000
```

---

# Step 8 — Access the Application

Open your browser and navigate to:

```
http://<EC2_PUBLIC_IP>:3000
```

Example:

```
http://3.120.45.88:3000
```

If the page loads successfully, your container is running correctly.

Note:

If running locally instead of EC2:

```
http://localhost:3000
```

---

# Step 9 — Stop the Container

To stop the running container:

First list containers:

```
docker ps
```

Copy the container ID.

Then stop the container:

```
docker stop <CONTAINER_ID>
```

Example:

```
docker stop abcd1234
```

---

# Step 10 — Confirm Container Stopped

Run:

```
docker ps
```

If no containers appear, the container has stopped successfully.

---

# Useful Docker Commands

List containers

```
docker ps
```

List all containers

```
docker ps -a
```

Stop container

```
docker stop <container-id>
```

Remove container

```
docker rm <container-id>
```

---

# Common Troubleshooting

### Cannot SSH to instance

Check:

* Key permissions (`chmod 400`)
* Correct username (`ubuntu`)
* Security group allows port 22

---

### Cannot access application

Ensure:

* Port 3000 is open in the EC2 Security Group
* Docker container is running:

```
docker ps
```

---

### Docker command not found

Restart the instance or ensure Docker installed via user-data script.

---

# Project Structure

Example repository structure:

```
project/
│
├── Dockerfile
├── docker-compose.yml
├── server.js
├── dist/
├── package.json
├── package-lock.json
└── README.md
```

---

# Conclusion

This guide demonstrated how to:

* Launch an AWS EC2 instance
* Install Docker automatically
* Connect using VS Code Remote SSH
* Deploy and run a containerized web application
* Access the application via a browser
