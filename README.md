# Private Voting (Inco Builders MVP)

> Minimal commit–reveal voting contract in Solidity. Built as a proof-of-concept for the **Inco** ecosystem.

![License](https://img.shields.io/badge/license-MIT-informational)
![Solidity](https://img.shields.io/badge/solidity-%5E0.8.20-blue)
![Status](https://img.shields.io/badge/status-MVP-success)

A tiny smart contract that demonstrates **private voting** without revealing a voter’s choice during the commit phase.  
Voters first submit a hashed commitment (`keccak256(vote, secret)`), and later **reveal** their vote with the same `secret`.  
This pattern is a natural fit for confidential apps that can be extended with **Inco Lightning** (TEE) and **Inco Atlas** (FHE/MPC).

---

## Quick links
- **Contract:** [`contracts/PrivateVoting.sol`](contracts/PrivateVoting.sol)  
- **Flow:** commit → deadline → reveal → tally  
- **Why Inco:** add verifiable confidential execution (Lightning) and full data privacy & programmable access control (Atlas).

---

## Table of Contents
1. How it works (Commit–Reveal)  
2. Deploy with Remix (step-by-step)  
3. Usage example  
4. Roadmap  
5. License
---

## 1. How it works (Commit–Reveal)

The contract follows a **two-phase process**:

1. **Commit phase**  
   - Each voter submits a hash of their choice and a secret.  
   - Hash format: `keccak256(vote, secret)`.  
   - The contract only stores commitments, not the actual votes.

2. **Reveal phase**  
   - Once the commit deadline has passed, voters reveal their choice by providing `(vote, secret)`.  
   - The contract recomputes the hash and checks that it matches the original commitment.  
   - Valid reveals are counted toward the final result.

3. **Tally**  
   - After the reveal period ends, the contract aggregates results.  
   - Any unrevealed commitments are ignored.

This scheme ensures **privacy during the commit stage** while still enabling transparent verification once votes are revealed.

---
---

## 2. Deploy with Remix (step-by-step)

Follow these steps to deploy the contract using [Remix IDE](https://remix.ethereum.org):

1. **Open Remix**  
   - Go to [remix.ethereum.org](https://remix.ethereum.org).  
   - Create a new file `PrivateVoting.sol` under the `contracts/` folder.  
   - Copy-paste the contract code from `contracts/PrivateVoting.sol`.

2. **Compile the contract**  
   - Select the **Solidity Compiler** tab.  
   - Ensure the version matches `0.8.20`.  
   - Click **Compile PrivateVoting.sol**.

3. **Deploy**  
   - Open the **Deploy & Run Transactions** tab.  
   - Select `PrivateVoting` from the contract dropdown.  
   - Configure parameters (e.g. commitDeadline, revealDeadline).  
   - Click **Deploy**.

4. **Commit a vote**  
   - Call `commitVote(bytes32 commitment)`.  
   - Generate the commitment using `keccak256(vote, secret)` locally.  
   - Submit the hash to the contract.

5. **Reveal a vote**  
   - After the commit phase ends, call `revealVote(vote, secret)`.  
   - The contract verifies the hash and counts the vote.

6. **Check results**  
   - Once the reveal deadline has passed, call `tallyVotes()`.  
   - The final result is stored on-chain.

---
---

## 3. Usage example

Here is a minimal usage flow:

1. **Generate commitment**  
   ```js
   // Example in JavaScript
   const { keccak256, toUtf8Bytes } = require("ethers");

   const vote = "yes";              // your vote
   const secret = "mySecret123";    // random secret
   const commitment = keccak256(
       ethers.utils.defaultAbiCoder.encode(
           ["string", "string"],
           [vote, secret]
       )
   );

   console.log("Commitment:", commitment);
