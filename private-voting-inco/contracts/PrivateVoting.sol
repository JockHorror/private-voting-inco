// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Private Voting Example (for Inco Builders Application)
/// @notice Простейший MVP приватного голосования на Solidity на основе commit-reveal.
/// @dev Для реального использования расширяйте через Inco SDK (Lightning/Atlas).
contract PrivateVoting {
    address public owner;
    uint256 public deadline;

    mapping(address => bytes32) private commitments;
    mapping(address => bool) public revealed;
    uint256 public votesYes;
    uint256 public votesNo;

    event Committed(address indexed voter, bytes32 commitment);
    event Revealed(address indexed voter, bool voteYes);

    constructor(uint256 _durationSeconds) {
        owner = msg.sender;
        deadline = block.timestamp + _durationSeconds;
    }

    /// @notice Вспомогательная функция для вычисления коммита (keccak256(vote, secret))
    function computeCommit(bool _voteYes, string memory _secret) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_voteYes, _secret));
    }

    /// @notice Участник фиксирует хэш от своего голоса + секрет
    function commitVote(bytes32 _commitment) external {
        require(block.timestamp < deadline, "Voting ended");
        commitments[msg.sender] = _commitment;
        emit Committed(msg.sender, _commitment);
    }

    /// @notice Участник раскрывает свой голос и секрет
    function revealVote(bool _voteYes, string memory _secret) external {
        require(block.timestamp >= deadline, "Reveal phase not started");
        require(!revealed[msg.sender], "Already revealed");
        require(
            commitments[msg.sender] == keccak256(abi.encodePacked(_voteYes, _secret)),
            "Invalid reveal"
        );

        revealed[msg.sender] = true;
        if (_voteYes) {
            votesYes++;
        } else {
            votesNo++;
        }
        emit Revealed(msg.sender, _voteYes);
    }

    /// @notice Возвращает победителя
    function result() external view returns (string memory) {
        require(block.timestamp >= deadline, "Voting not finished");
        if (votesYes > votesNo) return "YES wins";
        if (votesNo > votesYes) return "NO wins";
        return "TIE";
    }

    /// @notice Сколько секунд осталось до конца фазы коммита
    function timeLeft() external view returns (uint256) {
        if (block.timestamp >= deadline) return 0;
        return deadline - block.timestamp;
    }
}
