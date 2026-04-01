# CoreOverlay Package Structure

## Overview

This document describes the package structure of CoreOverlay and the responsibilities of each Swift package.

CoreOverlay is designed as a distributed execution and storage platform built around the following architectural principles:

- A Kademlia-based distributed hash table (DHT) for node discovery and routing
- A WebAssembly-based execution environment
- A distributed actor-oriented execution model
- A consistency model for distributed variables
- A storage architecture separated from the execution overlay when necessary

The package structure is intentionally designed to reflect these architectural boundaries.  
Each package should have a clear responsibility and a minimal, well-defined dependency surface.

The overall goal is to make CoreOverlay modular, testable, and incrementally implementable.

---

## Design Principles

The package structure follows these principles:

### 1. Clear Responsibility Boundaries

Each package should represent a distinct concern in the system, such as cryptography, networking, routing, execution, or storage.

### 2. Layered Dependency Direction

Low-level packages should not depend on high-level packages.  
For example, common types and cryptography should be usable independently from runtime or actor execution.

### 3. Replaceable Implementations

Where possible, packages should expose protocols or abstractions so that implementations may be replaced later.  
For example, the runtime may initially wrap one WebAssembly engine and later support others.

### 4. Incremental Development

The system should be buildable in stages.  
A minimal CoreOverlay node should be possible before actor execution, distributed storage, or strong consistency features are introduced.

---

## Package Layers

The packages are organized into the following conceptual layers:

1. Foundation packages
2. Networking and discovery
3. Overlay and routing
4. Storage and consistency
5. Runtime and execution
6. Security and observability
7. Node integration

---

## Package List

### CoreTypes

`CoreTypes` defines the shared foundational value types used across the entire system.

This package should contain small and stable data structures that represent the core identifiers and common domain values of CoreOverlay. Examples include node identifiers, actor identifiers, object identifiers, hashes, addresses, versions, timestamps, and similar primitives.

This package is intended to be the lowest-level dependency in the system.  
It should avoid depending on higher-level implementation details and should remain lightweight.

Typical responsibilities include:

- `NodeID`
- `ActorID`
- `ObjectID`
- `Hash`
- `PeerAddress`
- `Version`
- `LogicalTimestamp`

---

### CoreCrypto

`CoreCrypto` provides cryptographic primitives required by the overlay.

This package is responsible for hashing, key generation, signing, signature verification, and any cryptographic utilities used to secure communication or identify content. It supports trust, integrity, and identity across the distributed system.

This package should depend only on low-level foundational packages such as `CoreTypes`.

Typical responsibilities include:

- Hashing utilities
- Public/private key handling
- Digital signatures
- Signature verification
- Content hashing
- Identity-related cryptographic helpers

---

### CoreSerialization

`CoreSerialization` is responsible for encoding and decoding structured data exchanged between nodes or persisted by the system.

This includes serialization formats used for wire protocols, routing messages, metadata, and state exchange. The package should provide a consistent serialization boundary for the rest of the system.

The initial implementation may use a compact binary format such as CBOR, with the possibility of supporting additional formats later if needed.

Typical responsibilities include:

- Message encoding and decoding
- Binary serialization utilities
- Schema boundary definitions
- Framing helpers for network transport

---

### CoreNetworking

`CoreNetworking` provides the transport-level communication layer for CoreOverlay.

This package is responsible for establishing and managing peer-to-peer communication channels. It abstracts over the underlying transport so that upper layers can send and receive messages without being tightly coupled to a specific socket implementation.

The initial implementation may use TCP or QUIC, but the package should be designed so that transport details remain replaceable.

Typical responsibilities include:

- Peer connection management
- Message send and receive abstractions
- Connection lifecycle handling
- Stream or datagram transport abstraction
- Retry or reconnection support at the transport boundary

---

### CoreDiscovery

`CoreDiscovery` provides mechanisms for finding and learning about peers in the network.

Before routing tables become useful, nodes must discover at least some initial peers. This package supports bootstrap procedures, peer exchange, and discovery-related utilities.

This package is distinct from DHT routing itself. Its role is to help a node become aware of other nodes so that higher-level routing can begin.

Typical responsibilities include:

- Bootstrap peer discovery
- Peer exchange protocols
- Seed node handling
- Discovery workflows for joining the overlay

---

### CoreKademlia

`CoreKademlia` implements the Kademlia-based distributed hash table used for routing and lookup.

This is one of the central packages in CoreOverlay. It manages routing tables, buckets, node lookup procedures, and key-based search behavior. It forms the core addressing and lookup mechanism for the distributed network.

This package should be focused on DHT logic and should not absorb unrelated responsibilities such as execution or storage semantics.

Typical responsibilities include:

- Routing table management
- K-bucket maintenance
- `PING`
- `FIND_NODE`
- `FIND_VALUE`
- `STORE`
- Iterative or recursive lookup procedures
- Distance calculations based on node identifiers

---

### CoreRouting

`CoreRouting` provides higher-level overlay message routing on top of the DHT.

Where `CoreKademlia` is responsible for key-based lookup and neighbor knowledge, `CoreRouting` is responsible for message delivery semantics within the overlay itself. This may include multi-hop routing, overlay addressing, and routing policies used by higher-level subsystems.

Typical responsibilities include:

- Overlay message routing
- Multi-hop forwarding
- Address resolution
- Message envelope handling
- Delivery policy abstractions

---

### CoreStorage

`CoreStorage` provides the distributed storage layer for CoreOverlay.

This package is intended for content-addressed or chunk-based storage mechanisms that are logically distinct from the execution overlay. In the long term, this may represent a storage network that is separated from the execution network, even if both share some architectural concepts.

This package should focus on storing, retrieving, replicating, and managing immutable or versioned content.

Typical responsibilities include:

- Chunk storage
- Content addressing
- Metadata storage
- Replication control
- Pinning or retention policies
- Retrieval of stored objects

---

### CoreConsistency

`CoreConsistency` provides the consistency model for distributed state.

This package supports the semantics behind distributed variables and similar replicated state abstractions. It should provide mechanisms for eventual consistency, strong consistency where supported, local-only consistency modes, and conflict resolution strategies.

Because consistency strategy affects language/runtime behavior, this package is expected to become closely related to higher-level execution semantics.

Typical responsibilities include:

- Version vectors or logical clocks
- Conflict detection
- Conflict resolution
- CRDT-related primitives
- Consistency mode abstractions
- Replicated state merge behavior

---

### CoreRuntime

`CoreRuntime` provides the execution runtime for WebAssembly programs running on CoreOverlay.

This package is responsible for loading, instantiating, executing, and sandboxing WebAssembly modules. It forms the execution boundary for code deployed into the system and should abstract over the underlying WebAssembly engine.

The package should remain focused on runtime concerns rather than scheduling or distributed placement decisions.

Typical responsibilities include:

- WASM module loading
- Instance creation
- Host function integration
- Runtime sandboxing
- Memory and execution boundary handling
- Runtime error translation

---

### CoreExecution

`CoreExecution` manages execution control above the raw runtime.

While `CoreRuntime` is responsible for actually executing WebAssembly code, `CoreExecution` is responsible for how execution is scheduled, retried, timed out, and managed as a task within the distributed platform.

This package provides the operational execution model rather than the low-level VM interface.

Typical responsibilities include:

- Task scheduling
- Execution request handling
- Retry behavior
- Timeout management
- Resource-aware execution coordination
- Execution status tracking

---

### CoreActor

`CoreActor` provides the distributed actor abstraction used by CoreOverlay.

This package is responsible for actor lifecycle management, message delivery to actors, mailbox handling, and execution coordination between actor instances. Since CoreOverlay is designed around a distributed actor-oriented model, this package is expected to become a major architectural component.

It should provide the runtime-level machinery needed for actor-based execution without embedding unnecessary networking or storage details directly.

Typical responsibilities include:

- Actor identity and registration
- Actor lifecycle management
- Mailbox management
- Actor message dispatch
- Actor location or mobility support
- Distributed actor invocation handling

---

### CoreSecurity

`CoreSecurity` provides higher-level security mechanisms beyond raw cryptographic primitives.

Where `CoreCrypto` provides fundamental cryptographic operations, `CoreSecurity` is responsible for platform-level trust and authorization concerns. This may include capability tokens, permission models, execution authorization, trust verification, or policy enforcement.

Typical responsibilities include:

- Capability-based access control
- Authorization logic
- Execution permissions
- Trust policy evaluation
- Identity-to-permission mapping
- Secure operation guards

---

### CoreMonitoring

`CoreMonitoring` provides observability features for CoreOverlay.

Distributed systems become difficult to operate without strong visibility into execution, networking, routing, and failure behavior. This package should provide metrics, tracing, and structured logging facilities that can be integrated throughout the system.

Typical responsibilities include:

- Structured logging
- Metrics collection
- Tracing hooks
- Event reporting
- Health status instrumentation
- Diagnostic interfaces

---

### CoreNode

`CoreNode` integrates the major packages into a runnable CoreOverlay node.

This package acts as the composition root of the system. It is responsible for node startup, shutdown, configuration loading, subsystem wiring, and lifecycle orchestration. In other words, this package turns the individual modules into a coherent executable node.

`CoreNode` should not become a place where low-level logic is reimplemented. Instead, it should focus on assembly and orchestration.

Typical responsibilities include:

- Node configuration
- Dependency composition
- Startup and shutdown lifecycle
- Subsystem initialization
- Local node service orchestration
- Integration boundary for executable targets

---

## Suggested Initial Implementation Set

The full package structure is intended for long-term evolution.  
However, the initial implementation should start with a minimal subset.

The recommended first packages are:

- `CoreTypes`
- `CoreCrypto`
- `CoreSerialization`
- `CoreNetworking`
- `CoreKademlia`
- `CoreNode`

These packages are sufficient to create the initial foundation of the overlay and bring up a minimal distributed node.

---

## Suggested Development Order

A reasonable implementation order is as follows:

1. `CoreTypes`
2. `CoreCrypto`
3. `CoreSerialization`
4. `CoreNetworking`
5. `CoreDiscovery`
6. `CoreKademlia`
7. `CoreRouting`
8. `CoreRuntime`
9. `CoreExecution`
10. `CoreActor`
11. `CoreStorage`
12. `CoreConsistency`
13. `CoreSecurity`
14. `CoreMonitoring`
15. `CoreNode`

This order follows the dependency direction from low-level foundations to higher-level system integration.

---

## Dependency Direction

At a high level, dependencies should flow upward in the following way:

- `CoreTypes` as the foundational base
- foundational packages used by networking and routing
- routing and discovery used by execution and storage
- runtime and actor layers built on the communication substrate
- `CoreNode` integrating everything

This dependency direction should be preserved to prevent architecture erosion over time.

---

## Future Packages

Depending on how CoreOverlay evolves, additional packages may be introduced later.

### CoreLangRuntime

A runtime support package for CoreLang-specific semantics, especially if CoreLang introduces language-level abstractions that should not live directly in the generic runtime.

### CoreScheduler

A higher-level scheduler for placement, balancing, and distributed job orchestration.

### CoreGateway

An external interface package for HTTP APIs, gateways, or client-facing service access.

### CoreCLI

A command-line package for developer tooling, diagnostics, and node operations.

---

## Conclusion

The CoreOverlay package structure is designed to mirror the architecture of the system itself.

Rather than grouping code by convenience, the structure groups code by system responsibility. This makes the project easier to reason about, easier to evolve incrementally, and more robust as the platform grows from a minimal Kademlia-based overlay into a distributed execution and storage system.

The most important architectural rule is that package boundaries should remain meaningful.  
If each package preserves a clear and narrow responsibility, CoreOverlay will remain easier to maintain and extend over time.
