# Deploying a Dockerized Web Application on AWS EC2

This project demonstrates how to deploy a **Dockerized web application** on an **AWS EC2 instance** and connect to it using **VS Code Remote SSH**.

The process includes:

1. Launching an EC2 instance
2. Automatically installing Docker using a **user-data script**
3. Connecting to the instance using **VS Code Remote SSH**
4. Building a Docker image from a **Dockerfile**
5. Running the containerized application
6. Accessing the application via a browser

---

# Architecture Overview

The deployment uses the following components:

* Amazon Web Services EC2
* Docker for container runtime
* Visual Studio Code Remote SSH extension
* Ubuntu Linux EC2 instance

The application runs inside a Docker container and is exposed via **port 3000**.

---

# Prerequisites

Ensure you have the following before starting:

* AWS account
* SSH key pair (.pem)
* Visual Studio Code
* VS Code Remote SSH extension installed

Security group must allow:

```
SSH (22)
Custom TCP (3000)
```

---

# Step 1 — Launch the EC2 Instance

Login to AWS Console.

Navigate to:

```
EC2 → Launch Instance
```

Configuration:

* AMI: **Ubuntu Server**
* Instance type: `t2.micro` or `t3.micro`
* Key pair: create or select an existing key
* Security group rules:

```
SSH (22)
Custom TCP (3000)
```

---

# Step 2 — Install Docker Automatically Using user_data.sh

During EC2 launch configuration, use **User Data** to install Docker automatically.

Paste the content of User_data.sh script into the **User Data** field:

```bash
#!/bin/bash
............
............

```

This script installs Docker automatically when the instance starts.

---

# Step 3 — Locate Your Key Pair

Download your `.pem` file during instance creation.

Example:

```
my-keypair.pem
```

Copy the **absolute path** of the key.

### Windows

Right-click → **Copy as Path**

### macOS / Linux

Use:

```
pwd
```

or drag the file into the terminal.

---

# Step 4 — Set Key Permissions

Run:

```
chmod 400 my-keypair.pem
```

This is required for SSH authentication.

---

# Step 5 — Connect to the EC2 Instance Using VS Code

Open **Visual Studio Code**.

Install extension:

```
Remote - SSH
```

Then:

```
Ctrl + Shift + P
```

Select:

```
Remote-SSH: Connect to Host
```

Connect using:

```
ssh -i /path/to/keypair.pem ubuntu@<EC2_PUBLIC_IP>
```

Example:

```
ssh -i ~/keys/my-keypair.pem ubuntu@3.120.45.88
```

Select:

```
Linux
```

Click **Connect**.

---

# Step 6 — Verify Docker Installation

Confirm Docker was installed successfully:

```
docker --version
```

Expected output:

```
Docker version xx.x.x
```

Also confirm the Docker service is running:

```
systemctl status docker
```

---

# Step 7 — Build the Docker Image

Before running the container, build the image from the **Dockerfile**.

Navigate to your project directory.

Run:

```
docker build -t my-node-app .
```

This command creates the Docker image.

Confirm image creation:

```
docker images
```

---

# Step 8 — Run the Docker Container

Now start the container from the image:

```
docker run -d -p 3000:3000 --name myapp my-node-app
```

Explanation:

```
-d        run in background
-p        map ports
--name    container name
```

---

# Step 9 — Inspect Running Containers

To see running containers:

```
docker ps
```

Example output:

```
CONTAINER ID   IMAGE         PORTS
abc123         my-node-app   0.0.0.0:3000->3000
```

---

# Step 10 — Access the Application

Open a browser and navigate to:

```
http://<EC2_PUBLIC_IP>:3000
```

Example:

```
http://3.120.45.88:3000
```

Note:

If running locally instead of EC2:

```
http://localhost:3000
```

---

# Step 11 — Stop the Container

List containers:

```
docker ps
```

Copy the container ID.

Stop container:

```
docker stop <CONTAINER_ID>
```

Example:

```
docker stop abc123
```

---

# Step 12 — Confirm Container Has Stopped

Run:

```
docker ps
```

If no containers appear, the container has stopped successfully.

---

# Useful Docker Commands

Build image

```
docker build -t my-node-app .
```

List images

```
docker images
```

Run container

```
docker run -d -p 3000:3000 my-node-app
```

List running containers

```
docker ps
```

Stop container

```
docker stop <container-id>
```

Start container again

```
docker start <container-id>
```

Remove container

```
docker rm <container-id>
```

---

# Common Troubleshooting

### Cannot SSH to EC2

Check:

* Correct key permissions (`chmod 400`)
* Security group allows port **22**
* Correct username (`ubuntu`)

---

### Cannot access the application

Ensure:

* Port **3000** is open in EC2 Security Group
* Container is running:

```
docker ps
```

---

### Docker not installed

Check user-data logs:

```
/var/log/cloud-init-output.log
```

---

# Project Structure

Example project layout:

```
project/
│
├── Dockerfile
├── user_data.sh
├── server.js
├── dist/
├── package.json
├── package-lock.json
└── README.md
```

---

# Summary

This guide demonstrated how to:

* Launch an EC2 instance
* Install Docker automatically using **user-data**
* Connect via **VS Code Remote SSH**
* Build a Docker image from a Dockerfile
* Run the application container
* Access the application through the EC2 public IP
