// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
contract Lootbox is ERC721URIStorage {
    uint public boxPrice = 0.001 ether; //Price of a single Lootbox
    uint public maxItems = 15; // maximum number of items that can be minted from the lootbox
    mapping(address => uint) public boxes;
    constructor() ERC721("Lootbox", "LBG") {}
    function _baseURI() internal view virtual override returns (string memory) {
        return "ipfs://QmNXm5c3UdUwQGysndPPYHXmCmk216s9WSnLpPRFXgCBCJ/";
    }
    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        string memory baseURI = _baseURI();
        return
            bytes(baseURI).length > 0
                ? string(
                    abi.encodePacked(baseURI, Strings.toString(tokenId), ".json")
                )
                : "";
    }
    function buyBox() public payable {
        require(
            msg.value == boxPrice,
            "Send the correct amount to buy a lootbox"
        );
        boxes[msg.sender]++;
    }
    function openBox() public {
        require(boxes[msg.sender] > 0, "YOu must have a lootbox");
        boxes[msg.sender]--;
        uint256 randomTokenId = uint256(
            keccak256(abi.encodePacked(block.timestamp, msg.sender))
        ) % maxItems;
        mintEquipment(tokenURI(randomTokenId), randomTokenId);
    }
    function mintEquipment(
        string memory _tokenURI,
        uint tokenId
    ) internal returns (uint256) {
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, _tokenURI);
        return tokenId;
    }
}


//0xC3a43c8aBF2E289c16569770D0B8d2fc352713f0

