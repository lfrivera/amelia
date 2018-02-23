# FraSCAti helloworld-rmi

This folder contains the subsystems and deployments that allow to specify the deployment strategies (monolithic and distributed) for the helloworld-rmi example:

* **Client.amelia:** This subsystem allows to compile and execute the Client component in a specified host.

* **Server.amelia:** This subsystem allows to compile and execute the Server component in a specified host.

* **Deployment.amelia:** This file represents a monolithic deployment strategy (a *deployment* construct in the Amelia language) for the helloworld-rmi example. This deployment allows configuring (instantiating) the subsystems that are involved in the deployment process of the example. 

* **DistributedDeployment.amelia:** Similarly, this file represents a distributed deployment strategy (a *deployment* construct in the Amelia language) for the helloworld-rmi example.


