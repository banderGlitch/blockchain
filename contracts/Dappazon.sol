// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;



contract Dappazon {

    string public name;
    address public owner;


    struct Item {
        uint256 id;
        string name;
        string category;
        string image;
        uint256 cost;
        uint256 rating;
        uint256 stock;
    }

    struct Order {
        uint256 time;
        Item item;
    }

    mapping(uint256 => Item) public items;
    mapping(address => uint256) public orderCount;
    mapping(address => mapping(uint256 => Order)) public orders;
    
    event Buy(address buyer, uint256, uint256 itemId);
    event List(string name, uint256 cost, uint256 quantity);

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() {
        name = "Dappazon";
        owner = msg.sender;
    }
    function list(
        uint256 _id,
        string memory _name,
        string memory _category,
        string memory _image,
        uint256 _cost,
        uint256 _rating,
        uint256 _stock

    ) public onlyOwner {
        

        Item memory item = Item(

        _id,
        _name,
        _category,
        _image,
        _cost,
        _rating,
        _stock
        );

        items[_id] = item;
        emit List(_name, _cost, _stock);

      }
     function buy(uint256 _id) public payable  {
           
           // Fetch the item
            Item memory item = items[_id];

            //Require enough ether to buy item
            require(msg.value >= item.cost);

            //Require item is in stock
            require(item.stock > 0);

           // Create an order 
            Order memory order = Order(block.timestamp, item);

            // Add order for user and save
            orderCount[msg.sender] = orderCount[msg.sender] + 1;
            orders[msg.sender][orderCount[msg.sender]] = order;

            // Subtrack stock 
             items[_id].stock = item.stock - 1;

            // Emit event 
            emit Buy(msg.sender, orderCount[msg.sender], item.id);

    }
    // withdraw function from the smart contract can only be done by the owner itself

    function withdraw() public onlyOwner {
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success);
    }

}