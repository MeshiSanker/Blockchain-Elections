pragma solidity >=0.4.25;

contract Election {
    // Model a Candidate
    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }
    // bool to check if we are in elections
    bool canVote = false;
    // Store voters who can vote
    mapping(address => bool) public votersList;
    // Store accounts that have voted
    mapping(address => bool) public voters;
    // Store Candidates
    // Fetch Candidate
    mapping(uint256 => Candidate) public candidates;
    // Store Candidates Count
    uint256 public candidatesCount;

    // voted event
    event votedEvent(uint256 indexed _candidateId);

    constructor() public {
        addCandidate("Candidate 1");
        addCandidate("Candidate 2");
    }

    function addVoter(string _address) public {
        votersList[_address] = true;
    }

    function addCandidate(string _name) public {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function startPoll() public {
        canVote = true;
    }

    function endPoll() public {
        canVote = false;
    }

    function vote(uint256 _candidateId) public {
        // require that they haven't voted before and they arein the voters list
        require(votersList[msg.sender]);
        require(!voters[msg.sender]);
        // require to be in poll time
        require(canVote);
        // require a valid candidate
        require(_candidateId > 0 && _candidateId <= candidatesCount);

        // record that voter has voted
        voters[msg.sender] = true;

        // update candidate vote Count
        candidates[_candidateId].voteCount++;

        // trigger voted event
        emit votedEvent(_candidateId);
    }
}
