# DAOVault

DAO treasury with encrypted operations. Members see what happens, but amounts are hidden.

## Architecture

This implementation leverages Zama FHEVM's fully homomorphic encryption capabilities to enable computation on encrypted data. The system follows a self-relaying decryption model where decryption operations are performed off-chain via the Relayer SDK.

## Implementation Details

### Encryption Flow

1. Client-side encryption using FHEVM instance
2. Encrypted data submission to smart contract
3. On-chain computation on encrypted values
4. Optional decryption authorization via makePubliclyDecryptable()
5. Off-chain decryption through Relayer SDK
6. On-chain verification using signature verification

### Smart Contract Structure

- `DAOCore`

## Development

### Prerequisites

- Node.js 18+
- Hardhat 2.19+
- Sepolia testnet access

### Installation

`ash
npm install
`

### Compilation

`ash
npm run compile
`

### Configuration

Copy env.template to .env and configure:
- RPC_URL - Sepolia RPC endpoint
- PRIVATE_KEY - Deployer private key
- RELAYER_URL - Zama relayer endpoint

### Deployment

`ash
npm run deploy:sepolia
`

Contract addresses are written to contracts.json.

## Testing

`ash
npm test
`

## Technology Stack

- **@fhevm/solidity v0.9.1** - FHE operations in Solidity
- **@zama-fhe/relayer-sdk v0.3.0** - Off-chain decryption
- **@fhevm/hardhat-plugin v0.3.0** - Development tooling
- **Hardhat** - Development framework
- **TypeScript** - Type safety

## License

MIT


