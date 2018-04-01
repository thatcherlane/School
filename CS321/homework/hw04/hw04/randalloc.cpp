//
//  randalloc.cpp
//  hw04
//  cs321
//
//  Created by Thatcher Lane on 3/28/18.
//  Copyright © 2018 Thatcher Lane. All rights reserved.
//

#include <iostream>
using std::cout;
using std::endl;
using std::cin;
#include <string>
using std::string;
using std::getline;
#include <cstddef>
using std::size_t;
#include <limits>        
using std::numeric_limits;
using std::streamsize;
#include <algorithm>
using std::all_of;
#include <cctype>        // for isprint
#include <unistd.h>        // for _exit, write, close
#include <sys/mman.h>    // for mmap, munmap, related constants
#include <fcntl.h>        // for open, related constants
#include <sys/stat.h>     // for stat, struct stat
#include <sys/types.h>     // for off_t, ssize_t

// wait_exit
// Print blank line & prompt;
// wait for enter and exit after
void wait_exit(int code)
{
    if (code != 2) {
        cout << "\nPress ENTER to quit \n";
    }
    while (cin.get() != '\n') ;
    _exit(code);
}

// getFileSize
// takes name of file, attempt to determine file size.
// Returns size in bytes if successful. On error returns (-1).
off_t getFileSize(const string &fpath) {
    struct stat fileinfo;
    int stat_failure = stat(fpath.c_str(), &fileinfo);

    if (stat_failure) {
        return -1;
    }

    return fileinfo.st_size;
}

// closeFile
// Attempt to close given file descriptor
// on failure prints message and exits
void closeFile(int fd) {
    int closeFailed = close(fd);
    if(closeFailed) {
        cout << "Unable to close file.\n";
        cout << "Terminating\n";
        wait_exit(1);
    }
}

// doesFileExist
// Takes file path
// returns true if file exists
bool doesFileExist(const string& fpath) {
    struct stat fileinfo;
    return ( stat(fpath.c_str(), &fileinfo) == 0 );
}

// createFile
// Takes file name and creates a .txt file of given name with 100 dots
void createFile(const string &fpath) {
    const size_t SIZE = 100;
    ssize_t dummy;

    cout << "Creating '" << fpath << "'\n";
    int fd = open(fpath.c_str(),
                  O_RDWR | O_CREAT,
                  0666);

    if (fd == -1)
    {
        cout << "Unable to open " << fpath << "\n";
        wait_exit(1);
    }

    for (size_t i = 0; i < SIZE; ++i)
    {
        dummy = write(fd, ".", 1);
    }
    dummy = write(fd, "\n", 1);

    closeFile(fd);
}

// readFile
// takes fpath and allows the user to read an index from 0-99
// calls initFile if file doesn't exist
void readFile(const string &fpath) {
    if(!doesFileExist(fpath)) {
        cout << "\n" << fpath << " does not exist.\n";
        createFile(fpath);
    }
    else {
        cout << fpath << " already exists.\n";
    }

    int fd = open(fpath.c_str(),
                  O_RDONLY,
                  0644);

    if (fd == -1) {
        cout << "Unable to open " << fpath << "\n";
        cout << "Program terminating.\n";
        wait_exit(1);
    }
    cout << fpath << " opened.\n";

    int findIndex;
    do {
        std::cout << "What index would you like to read? (0-99)\n";
        while ( !(cin >> findIndex) ) {
            cin.clear();
            cin.ignore(numeric_limits<streamsize>::max(), '\n');
            cout << "Please enter a valid index. (0-99)\n";
        }
        if (findIndex < 0 || findIndex > 99) {
            cout << "Invalid index\n";
        }
    } while (findIndex < 0 || findIndex > 99);

    void *addr = mmap(nullptr,
                      getFileSize(fpath),
                      PROT_READ,
                      MAP_SHARED,
                      fd,
                      0);

    if (addr == MAP_FAILED) {
        cout << "mmap failed.\n";
        closeFile(fd);
    }

    char *memoryMap = (char *)addr;
    cout << "The value at " << findIndex << " is " << memoryMap[findIndex] << "\n";

    int munmap_failure = munmap(addr,
                                getFileSize(fpath));

    if (munmap_failure) {
        cout << "munmap failed.\n";
        closeFile(fd);
        wait_exit(1);
    }
    closeFile(fd);
}

// writeToFile
// Takes fpath and allows the user to write to an index between 0 and 99
// If file DNE, writeToFile calls createFile.
void writeToFile(const string &fpath) {
    if(!doesFileExist(fpath)) {
        cout << "\n" << fpath << " does not exist.\n";
        createFile(fpath);
    }
    else {
        cout <<fpath << " already exists.\n";
    }

    const size_t SIZE = 100;
    ssize_t dummy;

    int fd = open(fpath.c_str(),
                  O_RDWR,
                  0644);

    if (fd == -1)
    {
        cout << "Unable to open " << fpath << "\n";
        cout << "Program terminating.\n";
        wait_exit(1);
    }
    cout <<  fpath << " opened.\n";

    void * addr = mmap(nullptr,
                       SIZE,
                       PROT_READ | PROT_WRITE,
                       MAP_SHARED,
                       fd,
                       0);

    if (addr == MAP_FAILED)
    {
        cout << "mmap FAILED.\n";
        closeFile(fd);
        wait_exit(1);
    }

    off_t findIndex;
    do {
        std::cout << "What index do you want to edit? (0-99)\n";
        while ( !(cin >> findIndex) ) {
            cin.clear();
            cin.ignore(numeric_limits<streamsize>::max(), '\n');
            cout << "Please enter a valid index. (0-99)\n";
        }
        if (findIndex < 0 || findIndex > 99) {
            cout << "Invalid index\n";
        }
    } while (findIndex < 0 || findIndex > 99);

    while (cin.get() != '\n')
        ;

    cout << "\nEnter a character to be written at index " << findIndex << "\n";
    string input;
    getline(cin, input);
    while( (!(::isprint(input[0]))) || (input.length() > 1) ) {
        cout << "Please enter a character.\n";
        getline(cin, input);
    }

    char data = input[0];
    char * writeArray = (char *)addr;
    writeArray[findIndex] = data;

    int munmap_failure = munmap(addr,
                                SIZE);

    if (munmap_failure) {
        cout << "munmap failed.\n";
        closeFile(fd);
        wait_exit(1);
    }
    cout << "Write successful\n";
    closeFile(fd);
}


int main()
{
    int choice = 0;
    do {
        string fpath;
        cout << endl << endl;
        cout << "This Program writes to a file\n";
        cout << "Press ENTER to continue.\n\n";
        while (cin.get() != '\n');
        do {

            cout << "Please enter a file you would like to access" << endl;
            cout << "File must be in .txt format" << endl;
            getline(cin, fpath);
            if ((!(all_of(fpath.begin(), fpath.end(), ::isgraph))) ||
                !(fpath.length() > 4 && fpath.substr( fpath.length() - 4 ) == ".txt" )) {
                cout << "Invalid filename!\n";
            }
        } while ( (!(all_of(fpath.begin(), fpath.end(), ::isgraph
                            ))) ||
                 !(fpath.length() > 4 && fpath.substr( fpath.length() - 4 ) == ".txt" ) );
        cout << endl << "What would you like to do?" << endl;
        cout << "(1) Read a record." << endl;
        cout << "(2) Write to a record." << endl;
        cout << "(3) Exit." << endl;
        cout << "Please enter a choice." << endl;
        while (!(cin >> choice)) {
            cin.clear();
            cin.ignore(numeric_limits<streamsize>::max(), '\n');
            cout << "Invalid choice, please try again." << endl;
        }
        switch (choice) {
            case 1:
                readFile(fpath);
                break;

            case 2:
                writeToFile(fpath);
                break;

            case 3:
                wait_exit(2);
                break;

            default
                :
                cout << "Invalid choice, please try again.\n";
                break;
        }
    } while(choice != 3);

    wait_exit(0);
}
