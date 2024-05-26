// SIMPLE VOTING WITH ADDRESSES

// 1. Candidate Registration
// 2. Voting System
// 3. Winner Calculation and Vote Counting.


// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;


contract SimpleVoting {
    // Create Candidate Object
    struct Candidate {
        address id;
        string name;
        uint256 voteCount;
    }

    // Register Candidates and make them unique voters, vote once.
    mapping(address => Candidate) public candidates;
    mapping (address => bool) public hasVoted;
    address[] public candidateAddresses;

    // Log candidate registration
    event candidateRegistered(address candidateAddress, string candidateName);

    // Log votes
    event voteCast(address voter, address candidate);


    // Register Candidates
    // Register voteCounts, name of candidate, address.

    function registerCandidate(string memory _name) public {
        require(bytes(_name).length > 0, "You must specify the name of the Candidate");
        require(candidates[msg.sender].id == address(0), "Candidate is already registered");

        candidates[msg.sender] = Candidate({
            id: msg.sender,
            name: _name,
            voteCount: 0

        });

        candidateAddresses.push(msg.sender);
        emit candidateRegistered(msg.sender, _name);

    }

    // Voting function through candidates address not name.
    // Checks the ID of the current Candidate that is voting.
    // Unique votes.
    

    function vote(address _candidateAddress) public {
        require(candidates[_candidateAddress].id != address(0), "Candidate does not exist");
        require(!hasVoted[msg.sender], "You already voted!");

        hasVoted[msg.sender] = true;
        candidates[_candidateAddress].voteCount += 1;
        emit voteCast(msg.sender, _candidateAddress);
    }

    // Function to declare winner. 
    // Vote Counting 
    // In case of tie, returns candidates with the highest votes.

    function getWinner() public view returns (address[] memory) {
        uint256 maxVotes = 0;
        uint256 winnerCount = 0;

        for (uint256 i = 0; i < candidateAddresses.length; i++) {
            if (candidates[candidateAddresses[i]].voteCount > maxVotes) {
                maxVotes = candidates[candidateAddresses[i]].voteCount;
                winnerCount = 1;
            } else if (candidates[candidateAddresses[i]].voteCount == maxVotes) {
                winnerCount ++;
            }
        }
        address [] memory winners = new address[](winnerCount);
        uint256 index = 0;
        for (uint256 i = 0; i < candidateAddresses.length; i++){
            if (candidates[candidateAddresses[i]].voteCount == maxVotes){
                winners[index] = candidateAddresses[i];
                index++;
            }
        }
        return winners;
    }

}
