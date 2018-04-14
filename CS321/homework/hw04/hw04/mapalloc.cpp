//
//  mapalloc.cpp
//  hw04
//  cs321
//
//  Created by Thatcher Lane on 3/28/18.
//  Copyright © 2018 Thatcher Lane. All rights reserved.
//

#include "mapalloc.h"
#include <map>
using std::map;
using std::size_t;

map<void *, size_t> memBlockSize;

//mapAolloc
//takes size_t which indicates the number of bytes to be allocated
//returns a void pointer to the allocated memory
void * mapAlloc(size_t bytes) {
    void * addr = mmap(nullptr, bytes, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);

    if (addr==MAP_FAILED) {
        return nullptr;
    }
    else {
        memBlockSize[addr] = bytes;
        return addr;
    }
}

//mapFree
//takes a void pointer that points to a memory block
//retruns nothing, and deallocated the memory at the given pointer
void mapFree(void * memptr) {
    munmap(memptr,memBlockSize[memptr]);
}
