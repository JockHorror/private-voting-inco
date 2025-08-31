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
