# racktopia

**racktopia** is a personal infrastructure workspace for building, operating, and experimenting with automated
systems at homelab scale.

The name is intentional, but not precious.

- **rack** refers to physical and virtual server racks: compute, storage, networks
- **topia** refers to a constructed place: something built, inhabited, maintained

This is not a claim that infrastructure is perfect or complete.  
It is a name for a *habitable system space*.

---

## Naming philosophy

The repositories in this org use unconventional names.  
Each name describes the **final state the repository produces**, not the tools used inside it.

The stack is intentionally layered:

### `substrate`

Turns heterogeneous VPSes and VMs into fungible Debian hosts.

When this layer is done, machines have no identity beyond capacity.
They are interchangeable matter ready to be organized.

---

### `abstract-machine`

Organizes substrate into coherent Kubernetes clusters.

This layer does not deploy workloads.
It instantiates the *diagram* that makes workloads possible:
nodes, constraints, schedulers, networks.

It is structure without intention.

---

### `teleoplexy`

Deploys systems whose requirements compel the existence and shape of the layers below.

This layer is driven by outcomes, not provisioning.
It applies selection pressure upstream through automation, CI, and operational necessity.

---

## Why this structure exists

Modern infrastructure is increasingly shaped by feedback loops rather than plans:

- systems optimize for survivability, speed, and compatibility
- successful patterns reproduce themselves
- manual intervention becomes a liability

These repositories are named to reflect that reality honestly.

The optimism is in *making the system legible*,
not in pretending it is fully under control.

---

## What this is (and isn’t)

This org is:

- a homelab
- an automation playground
- a place to test ideas about infrastructure as systems

It is not:

- a product
- a manifesto
- a claim of inevitability

The naming borrows language from systems theory and philosophy,
but the work here is practical and concrete.

---

## In short

**racktopia** is a place to build infrastructure that acknowledges how modern systems actually behave,
while still being something a human can live with.

If that sounds slightly utopian, that’s intentional.
