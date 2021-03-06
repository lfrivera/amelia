# FraSCAti helloworld-rmi

This example installs Java 1.6.0_23 & FraSCAti 1.4 (if not installed) and compiles and executes the helloworld-rmi project from the FraSCAti distribution. There are two deployment variants: monolithic and distributed deployment. The first one runs both server and client components in the same server, and the second one uses two hosts.

The __monolithic__ strategy ([Deployment.amelia](src/main/amelia/org/amelia/dsl/examples/ubuntu/frascati/demo/Deployment.amelia)) requires specifying the following parameters:

- __host__: the target host name
- __privileged-user__: a privileged user to install Java and FraSCAti
- __unprivileged-user__: an unprivileged user to execute the components

By default, the project pom defines these parameters as follow:

- host = localhost
- privileged-user = root
- unprivileged-user = ${user.name} # the user running maven

The __distributed__ strategy ([DistributedDeployment.amelia](src/main/amelia/org/amelia/dsl/examples/ubuntu/frascati/demo/DistributedDeployment.amelia)) requires specifying the following parameters:

- __host-server__: the target host name for the server component
- __host-client__: the target host name for the client component
- __privileged-user__: a privileged user to install Java and FraSCAti
- __unprivileged-user__: an unprivileged user to execute the components
- __mainClass__: org.amelia.dsl.examples.ubuntu.frascati.demo.DistributedDeployment

Both users are expected to exist in the target hosts.

By default, the project pom defines these parameters as follow:

- host-server = localhost
- host-client = localhost
- privileged-user = root
- unprivileged-user = ${user.name} # the user running maven

To run the example:

1. [Package and install the language artefacts](/README.md#compiling-from-sources)
2. Execute the Java application generated by the Amelia compiler:

```bash
mvn exec:java -Dhost=... # specify here the rest of the parameters
```

If everything ran correctly, you should see the following message:

```
Client process running on PID <number>
```
