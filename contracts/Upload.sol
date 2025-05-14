// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Upload {
    struct Access {
        address user;
        bool access;
    }

    mapping(address => string[]) internal value;
    mapping(address => Access[]) public accessList;
    mapping(address => mapping(address => bool)) public ownership;
    mapping(address => mapping(address => bool)) public previousData;

    function add( address _adr,string memory url) external {
        value[_adr].push(url);
    }

    function allow(address user) external {
        ownership[msg.sender][user] = true;
        if (previousData[msg.sender][user]) {
            for (uint256 i = 0; i < accessList[msg.sender].length; i++) {
                if (accessList[msg.sender][i].user == user) {
                    accessList[msg.sender][i].access = true;
                }
            }
        } 
        else {
            accessList[msg.sender].push(Access(user,true));
            previousData[msg.sender][user] = true;
        }
    }

    function disallow(address user) public {
        require(ownership[msg.sender][user] ,"Not Allowed...");
        ownership[msg.sender][user] = false;
        for (uint256 i = 0; i < accessList[msg.sender].length; i++) {
            if (accessList[msg.sender][i].user == user) {
                require(
                    accessList[msg.sender][i].access == true,
                    "already disallowed..."
                );
                accessList[msg.sender][i].access = false;
            }
        }
    }

    function display(address adr) external view returns(string[] memory){
        require(adr==msg.sender || ownership[adr][msg.sender],"user not registered...");
        return value[adr];
    }

    function shareAccess() public view returns(Access[] memory){
        return accessList[msg.sender];
    }
}
