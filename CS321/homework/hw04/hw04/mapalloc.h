//
//  mapalloc.hpp
//  hw04
//  cs321
//
//  Created by Thatcher Lane on 3/28/18.
//  Copyright © 2018 Thatcher Lane. All rights reserved.
//

#ifndef mapalloc_hpp
#define mapalloc_hpp

#include <stdio.h>
#include <cstddef> // for size_t
#include <sys/mman.h> // for mmap, munmap

void * mapAlloc(std::size_t bytes);
void mapFree(void * memptr);

#endif /* mapalloc_hpp */
