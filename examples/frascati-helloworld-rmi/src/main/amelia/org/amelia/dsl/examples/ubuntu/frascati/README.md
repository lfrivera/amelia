# FraSCAti helloworld-rmi

This folder contains the source code (i.e., subsystems and deployments specified in the Amelia language) used for specifying the deployment of the helloworld-rmi example:

* **FraSCAti.amelia:** This subsystem allows validating whether FraSCAti 1.4 is already installed on the declared hosts. In case FraSCAti is not installed, this subsystem proceeds to download, install, and configure the FraSCAti binaries.

* **Java.amelia:** Similarly, this subsystem allows to download, install, and configure the Java Development Kit (JDK) version 1.6.0_23, which is required for compiling and executing FraSCAti components.

The folder *demo* contains the subsystems and deployments that allow to specify the deployment strategies for the helloworld-rmi example. All these files (.amelia files) should be compiled following the [guidelines](/README.md#compiling-from-sources) provided in the main page of this repository.

