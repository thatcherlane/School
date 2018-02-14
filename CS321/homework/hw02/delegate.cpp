//  Thatcher Lane
//  CS 321 Spring 2018
//  hw02 - delegate.cpp

//  Code used to spawn threads originally from race6.cpp written by Dr. Chappel in class. Original
//  documentation bellow.
//        race6.cpp
//        Glenn G. Chappell
//        2 Feb 2018
//
//        For CS 321 Spring 2018
//        Fix Race Condition: Mutex + Scoped Lock Guard - Efficiency

#include <iostream>
#include <thread>
#include <vector>
#include <queue>
#include <limits>
#include <ios>
#include <cstdlib>
#include <mutex>
#include "sa2a.h"

const int NUMTHREADS = 6;
int count;
std::mutex count_mutex;
std::queue<int> inputQue;
std::queue<int> outputQue;

int getInputValue() {
    int getValueFromUser;
    while(true) {
        if(std::cin >> getValueFromUser && getValueFromUser >= 0) {
            return getValueFromUser;
        }
        else {
            std::cout << "Error in input, please enter a positive integer, or 0 to exit: ";
            std::cin.clear();
            std::cin.ignore(std::numeric_limits<std::streamsize>::max(),'\n');
        }
    }
}

void run() {
    int argVal;
    int retVal;
    bool empty = false;
    bool goYet = false;

    //Check for empty queue
    {
        std::lock_guard<std::mutex> count_guard(count_mutex);
        empty = inputQue.empty();
    }

    //while queue not empty continue reading and performing sa2
    while(!empty) {
        {
            std::lock_guard<std::mutex> count_guard(count_mutex);

            if(!inputQue.empty()) {
                argVal = inputQue.front();
                inputQue.pop();
                goYet = true;
            }
            else {
                goYet = false;
            }
        }

        if(goYet) {
            retVal = sa2a(argVal);
            {
                std::lock_guard<std::mutex> count_guard(count_mutex);
                outputQue.push(argVal);
                outputQue.push(retVal);
                empty = inputQue.empty();
            }
        }
    }
}

// Main
// Spawns threads. Each using run() function to avoid race conditions.
// Then joins all and prints results.
int main() {
    count = 0;
    int inputValue;
    std::cout << "Delegated Computation" << std::endl << std::endl;
    std::cout << "Enter a positive integer (or 0 to end input): ";
    inputValue = getInputValue();

    while (inputValue > 0) {
        inputQue.push(inputValue);
        count++;
        std::cout << "Enter a positive integer (or 0 to end input): ";
        inputValue = getInputValue();
    }

    std::cout << "Input collection finished."<< std::endl;
    std::cout << "Processing values." << std::endl;

    std::vector<std::thread> ts(NUMTHREADS);

    // Spawn Threads
    for (int i = 0; i < NUMTHREADS; ++i) {
        try {
            ts[i] = std::thread(run);
        }
        catch(...) {
            std::cout << std::endl;
            std::cout << "ERROR: It appears that we can only spawn " << i << " threads on this system." << std::endl;
            std::cout << "  Try reducing NUMTHREADS to " << i << " and recompiling." << std::endl;
            std::exit(1);
        }
    }

    // Join Threads
    int check = 0;
    while (check < count) {
        if(!outputQue.empty()) {
            std::cout << "sa2a(" << outputQue.front() << ") = ";
            outputQue.pop();
            std::cout << outputQue.front() << std::endl;
            outputQue.pop();
            check++;
        }
    }

    for (int i = 0; i < NUMTHREADS; ++i) {
        ts[i].join();
    }

    std::cout << "Well done slaves! All done now!" << std::endl;
    return 0;
}
