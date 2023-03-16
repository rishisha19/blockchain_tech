// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Token contract

contract MyToken {
    string public name = "My Token";
    string public symbol = "MTK";
    uint256 public totalSupply = 1000000;
    uint8 public decimals = 18;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    constructor() {
        // Mint all tokens to the contract owner
        balances[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function name() public view virtual returns (string memory) {
        return name;
    }

    function symbol() public view virtual returns (string memory) {
        return symbol;
    }

    function decimals() public view virtual returns (uint8) {
        return decimals;
    }

    /**
    * @dev Returns the total supply of the token.
     */
    function totalSupply() public view returns (uint256) {
        return totalSupply;
    }

    /**
     * @dev Returns the balance of the given account.
     */
    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through `transferFrom`. This is
     * zero by default.
     */
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     *
     */
    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(_spender != address(0), "Invalid address.");
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
     * @dev Transfers tokens from one address to another.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        require(balances[sender] >= amount, "Not enough balance.");
        require(allowed[sender][msg.sender] >= amount, "Not enough allowance.");
        require(recipient != address(0), "Invalid address.");

        balances[sender] -= amount;
        balances[recipient] += amount;
        allowed[sender][msg.sender] -= amount;

        emit Transfer(sender, recipient, amount);

        return true;
    }

    /**
     * @dev Transfers tokens to the specified recipient.
     */
    function transfer(address recipient, uint256 amount) public  returns (bool) {
        require(balances[msg.sender] >= amount, "Not enough balance.");
        require(recipient != address(0), "Invalid address.");

        balances[msg.sender] -= amount;
        balances[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);

        return true;
    }

}
