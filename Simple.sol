// // SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
// contract Simple {
//     struct Child {
//         uint8 id;
//         uint8 count;
//     }
//     struct Parent {
//         mapping(uint => Child) children;
//         uint childrenSize;
//     }

//     Parent[] parents;

//     function testWithEmptyChildren() public {
//         Parent storage newParent = parents.push();
//         newParent.childrenSize = 0;
//     }
//     function testWithChild(uint index) public {
//         Parent storage p = parents[index];

//         p.children[p.childrenSize] = Child();
//         p.childrenSize++;
//     }
// }
