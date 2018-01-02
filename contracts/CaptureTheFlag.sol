pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";

contract CaptureTheFlag is Ownable {
  using SafeMath for uint256;

  uint256                     public prize;          // 賞金
  mapping(address => bytes32) public answers;        // 正解の辞書
  uint256                     public deadline;       // 終了時間
  bool                        public isOver = false; // 競技が終了しているか

  function CaptureTheFlag(uint256 _prize, address[] _participants, bytes32[] _answers, uint256 _timedelta) public {
    require(_participants.length == _answers.length);

    // 正解の辞書の構築
    for (uint i = 0; i < _participants.length; i++) {
      answers[_participants[i]] = _answers[i];
    }

    prize        = _prize;
    deadline     = block.timestamp.add(_timedelta);
  }

  // 主催者のみが賞金を入金できるようにする
  function () external payable onlyOwner {}

  // 参加者が正解を提出する
  function submit(bytes32 answer) public {
    require(!isOver);                    // 競技がまだ終了していないこと
    require(block.timestamp < deadline); // 終了時間をまだ過ぎていないこと
    require(this.balance >= prize);      // 賞金が既に入金されていること

    // 提出されたハッシュが正解かどうかを検証する
    bytes32 hashedAnswer  = sha256(answer);
    bytes32 correctAnswer = answers[msg.sender];
    require(correctAnswer != 0x0);
    require(correctAnswer == hashedAnswer);

    // 正解であれば賞金を支払い競技を終了する
    msg.sender.transfer(prize);
    isOver = true;
  }

  // 賞金を主催者に返還する
  function refund() public {
    require(block.timestamp >= deadline);  // 終了時間を過ぎていること
    owner.transfer(this.balance);
  }
}
