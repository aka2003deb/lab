#include <iostream>
#include <windows.h>
using namespace std;

// Function to determine the memory segment based on the address
const char* getMemorySegment(const void* address) {
    // Get system information to determine memory ranges
    SYSTEM_INFO sysInfo;
    GetSystemInfo(&sysInfo);

    // Convert the address to a uintptr_t for comparison
    uintptr_t addr = reinterpret_cast<uintptr_t>(address);

    // Typical memory ranges for 64-bit Windows
    uintptr_t codeStart = reinterpret_cast<uintptr_t>(GetModuleHandle(nullptr)); // Start of code segment
    uintptr_t codeEnd = codeStart + 0x100000; // Approximate end of code segment (1 MB)
    uintptr_t dataStart = codeEnd; // Start of initialized data segment
    uintptr_t dataEnd = dataStart + 0x100000; // Approximate end of initialized data segment (1 MB)
    uintptr_t bssStart = dataEnd; // Start of BSS segment
    uintptr_t bssEnd = bssStart + 0x100000; // Approximate end of BSS segment (1 MB)
    uintptr_t rodataStart = bssEnd; // Start of read-only data segment
    uintptr_t rodataEnd = rodataStart + 0x100000; // Approximate end of read-only data segment (1 MB)
    uintptr_t heapStart = reinterpret_cast<uintptr_t>(GetProcessHeap()); // Start of heap segment
    uintptr_t heapEnd = heapStart + 0x10000000; // Approximate end of heap segment (256 MB)

    // Approximate stack start using the address of a local variable in the main function
    int stackVar;
    uintptr_t stackStart = reinterpret_cast<uintptr_t>(&stackVar); // Approximate start of stack segment
    uintptr_t stackEnd = static_cast<uintptr_t>(0x7FFFFFFFFFFF); // End of stack segment (top of user-mode address space)

    // Determine the memory segment
    if (addr >= codeStart && addr < codeEnd) {
        return "Code Segment";
    } else if (addr >= dataStart && addr < dataEnd) {
        return "Initialized Data Segment";
    } else if (addr >= bssStart && addr < bssEnd) {
        return "Uninitialized Data Segment (BSS)";
    } else if (addr >= rodataStart && addr < rodataEnd) {
        return "Read-Only Data Segment";
    } else if (addr >= heapStart && addr < heapEnd) {
        return "Heap Segment";
    } else if (addr >= stackStart && addr <= stackEnd) {
        return "Stack Segment";
    } else {
        return "Unknown Segment";
    }
}

int main() {
    // Stack Segment: Local variable
    int stackVar = 42;
    cout << "Address of stackVar: " << &stackVar << " and it lies in " << getMemorySegment(&stackVar) << endl;

    // Heap Segment: Dynamically allocated variable using 'new'
    int* heapVar = new int(100); // Allocate memory using 'new'
    cout << "Address of heapVar: " << heapVar << " and it lies in " << getMemorySegment(heapVar) << endl;
    delete heapVar; // Free memory using 'delete'

    // Initialized Data Segment: Global initialized variable
    static int dataVar = 200;
    cout << "Address of dataVar: " << &dataVar << " and it lies in " << getMemorySegment(&dataVar) << endl;

    // Uninitialized Data Segment (BSS): Global uninitialized variable
    static int bssVar;
    cout << "Address of bssVar: " << &bssVar << " and it lies in " << getMemorySegment(&bssVar) << endl;

    // Read-Only Data Segment: Constant variable
    const char* rodataVar = "This is a read-only string";
    cout << "Address of rodataVar: " << reinterpret_cast<const void*>(rodataVar) << " and it lies in " << getMemorySegment(reinterpret_cast<const void*>(rodataVar)) << endl;

    // Code Segment: Function address
    void (*codeVar)() = []() { cout << "Code Segment Function" << endl; };
    cout << "Address of codeVar: " << reinterpret_cast<void*>(codeVar) << " and it lies in " << getMemorySegment(reinterpret_cast<void*>(codeVar)) << endl;

    return 0;
}
