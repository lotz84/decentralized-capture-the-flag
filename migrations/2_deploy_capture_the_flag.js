const crypto = require('crypto');
const CaptureTheFlag = artifacts.require('./CaptureTheFlag.sol');

const sha256 = (msg) => crypto.createHash('sha256').update(msg).digest();

const prize = 1e18; // 1 ether
const flagWord = Buffer.from("capture the flag", 'utf8');

const participants = [
  "f17f52151ebef6c7334fad080c5704d77216b732",
  "c5fdf4076b8f3a5357c5e395ab970b5b54098fef",
  "821aea9a577a9b44299b9c15c88cf3087f3b5544",
  "0d1d4e623d10f9fba5db95830f7d3839406c6af2",
  "2932b7a2355d6fecc4b5c0b6bd44cc31df247a2e",
  "2191ef87e392377ec08e7c08eb105ef5448eced5",
  "0f4f2ac550a1b4e2280d04c21cea7ebd822934b5",
  "6330a553fc93768f612722bb8c2ec78ac90b3bbc",
  "5aeda56215b167893e80b4fe645ba6d5bab767de",
  ]
  .map((address) => Buffer.from(address, 'hex'))

const answers = participants.map((address) => {
  const msg = Buffer.concat([address, flagWord]);
  console.log("DEBUG", "0x" + sha256(msg).toString('hex'));
  return sha256(sha256(msg));
});

const timedelta = 60 * 60; // 1 hours

// Buffer から String に変換
const buf2str = (buf) => "0x" + buf.toString('hex');

module.exports = (deployer) => {
  deployer.deploy(
    CaptureTheFlag,
    prize,
    participants.map(buf2str),
    answers.map(buf2str),
    timedelta
  )
};
