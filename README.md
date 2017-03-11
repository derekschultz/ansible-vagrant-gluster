# Exercise
Create a mulit-node GlusterFS storage cluster with sufficient fault tolerance
to survive a single node failure with no loss of data.

## Acceptence Criteria:
* the cluster must successfully deploy from scratch by running a single command or script
* a single networked GlusterFS filesystem should be created and mounted on all nodes in the cluster
* destruction of a single node in the cluster should not result in any data loss on the GlusterFS filesystem

## Things we will be looking for in your completed evaluation:
* Required functionality as outlined above
* Proficiency with modern tools slated for this approach
* Idempotency
* Overall best practices for the tools, languages, and/or approaches you use
* Updates to this README.md file describing your solution along with any known issues