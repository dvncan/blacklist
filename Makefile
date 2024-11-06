-include .env

.PHONY: all test clean deploy-anvil deploy-sepolia

all: clean update build test snapshot remove install 

# Clean the repo
clean  :; forge clean

# Update Dependencies
update:; forge update

build:; forge build --via-ir

test :; forge test -vvv --via-ir

snapshot :; forge snapshot --via-ir

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m 'commit Deployed ${%y.%m.%d %H:%M:%S}'

# Install libs for forge tests optional include --no-commit
install :; forge install https://github.com/OpenZeppelin/openzeppelin-contracts.git  &&  forge install foundry-rs/forge-std


format :; prettier --write src/**/*.sol && prettier --write src/*.sol

# solhint should be installed globally
lint :; solhint src/**/*.sol && solhint src/*.sol

anvil :; anvil -m 'test test test test test test test test test test test junk'

# use the "@" to hide the command from your shell 
deploy-sepolia :; @forge script script/DeployBLS.s.sol:DeployBLS --private-key ${PRIVATE_KEY} --rpc-url ${SEPOLIA_RPC_URL} --via-ir --broadcast --verify --etherscan-api-key ${ETHERSCAN_API_KEY} -vvvv

# This is the private key of account from the mnemonic from the "make anvil" command
deploy-anvil :; @forge script script/DeployBLS.s.sol --rpc-url http://localhost:8545 --private-key ${PRIVATE_KEY_ANVIL} --via-ir --broadcast

# deploy-all :; make deploy-${network} contract=APIConsumer && make deploy-${network} contract=KeepersCounter && make deploy-${network} contract=PriceFeedConsumer && make deploy-${network} contract=VRFConsumerV2

-include ${FCT_PLUGIN_PATH}/makefile-external