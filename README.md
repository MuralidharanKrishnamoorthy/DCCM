# Decentralized Carbon Credit Marketplace (DCCM)

The **Decentralized Carbon Credit Marketplace (DCCM)** is a blockchain-based platform that enables transparent and secure trading of carbon credits. The platform leverages AI for carbon credit verification and uses Ethereum smart contracts to facilitate decentralized trading.

## Project Overview

The DCCM platform addresses the need for companies to offset their carbon emissions in a trustworthy and scalable way. By decentralizing the carbon credit trading process and using AI for project verification, DCCM ensures transparency, immutability, and global scalability.

## Technical Stack

- **Flutter**: Frontend framework for building cross-platform mobile applications (iOS, Android).
- **Web3.dart**: For integrating blockchain functionality with the Flutter frontend.
- **Ethereum Smart Contracts**: Written in Solidity for managing carbon credit issuance, trading, and retirement.
- **MongoDB**: Database used for storing platform data.
- **Node.js**: Backend server to handle API requests and business logic.
- **Mongoose**: ODM used for MongoDB data management.
- **IPFS (InterPlanetary File System)**: Used for decentralized storage of large project verification files.
- **Intel OneAPI**: Optimizes AI inference and machine learning models for estimating carbon credits efficiently at the edge.

## Project Review

### App Workflow

The **DCCM app** operates with two distinct roles: **land owners** and **companies**, each with their own workflow.

1. **User Logins**:
   - There are two types of logins in the app: 
     - **Land Owners**: These users are responsible for creating and submitting carbon credit projects.
     - **Companies**: These users are responsible for purchasing carbon credits to offset their carbon emissions.

2. **Company Workflow**:
   - **Companies** share their carbon offset data (e.g., how much carbon emissions they wish to offset).
   - They can browse available carbon credit projects verified by the platform and purchase carbon credits to meet their environmental goals.

3. **Land Owner Workflow**:
   - **Land owners** provide detailed data such as:
     - **Land Type**: The type of land being used for carbon credit projects (e.g., forest, grassland).
     - **Tree Species**: The species of trees that are planted on the land.
     - **Age of Trees**: The age of the trees in years.
   - This data is inputted into the platform, where an **AI model** predicts the number of carbon credits that the project can generate based on the provided information.

4. **AI-Powered Verification**:
   - Once land owners submit their projects, the platform's AI system processes the data and predicts the carbon credits.
   - These projects are initially placed under the **In-progress** tab.
   - After the verification process is completed, the projects move to the **Verified** tab, indicating that they are eligible for carbon credit trading.

5. **Carbon Credit Trading**:
   - Verified projects can issue carbon credits, which are made available for purchase by companies.
   - Companies can choose and buy these credits to offset their carbon footprint based on their offset data.

6. **Blockchain-Based Payment**:
   - The payment for carbon credits is securely processed using blockchain technology.
   - The currency used for these transactions is **USDC (USD Coin)**, a stablecoin built on the Ethereum blockchain.
   - Smart contracts manage the entire payment process, ensuring transparency, security, and immutability in each transaction.

## Features

1. **AI-Enhanced Carbon Credit Verification**: 
   - Uses machine learning models (Random Forest, Linear Regression) to estimate carbon credits based on parameters like plant species, land size, and plant age.

2. **Blockchain Transparency**: 
   - Ethereum smart contracts ensure the transparency and immutability of carbon credit transactions. The smart contracts automatically handle the issuance, trading, and retirement of carbon credits.

3. **Decentralized Storage**: 
   - Project verification documents and images are stored using IPFS, ensuring data security and decentralization.

4. **Edge Optimization with Intel OneAPI**: 
   - Ensures real-time AI performance even in resource-constrained environments.

## How to Get Started

### Prerequisites

- **Flutter SDK**: [Install Flutter](https://docs.flutter.dev/get-started/install)
- **Node.js**: Install Node.js from [here](https://nodejs.org/)
- **MongoDB**: Set up MongoDB locally or use [MongoDB Atlas](https://www.mongodb.com/cloud/atlas).
- **Web3.dart**: Install dependencies for blockchain integration.

### Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/MuralidharanKrishnamoorthy/DCCM.git
