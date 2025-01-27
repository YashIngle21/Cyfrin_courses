//SPDX-License-Identifier: MIT


pragma solidity 0.8.24; // Stating ur version the contract will only work on this version
//pragma solidity ^0.8.18 // '^'  used to denote that version greater than and equal will work
//pragma solidity >=0.8.18 <0.9.0 // version range it will work for


contract SimpleStorage{


    uint256 myfavNumber;

    //uint256[] listOfFavno;

    // struct same as C/cpp
    struct Person{
        uint256 FavNumber;
        string name;
    }

    //dynamic array 
    Person[] public listOfPeople;

    //static array --> mention the len of array  in the brackets 
    //Person[5] public listOfPeople;


    mapping(string => uint256) public nameToFavNumber;

    function store(uint256 _favNo) public virtual {
        myfavNumber = _favNo;
    }

    function retrieve() public view returns(uint256){
        return myfavNumber;
    }

    function addPerson(string memory _name,uint256 _FavNumber) public {
        listOfPeople.push(Person(_FavNumber,_name));
        nameToFavNumber[_name] = _FavNumber;
    }
}
