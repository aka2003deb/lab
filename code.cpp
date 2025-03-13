#include <windows.h>
#include <iostream>

// Function that attempts to classify the memory segment of a given address.
const char* getMemorySegment(const void* address) {
    MEMORY_BASIC_INFORMATION mbi;
    if (VirtualQuery(address, &mbi, sizeof(mbi)) == 0) {
        return "Unknown (VirtualQuery failed)";
    }

    // Try to get the stack boundaries (available on Windows 8 and later)
    ULONG_PTR stackLow = 0, stackHigh = 0;
    typedef void(WINAPI * GetCurrentThreadStackLimits_t)(PULONG_PTR, PULONG_PTR);
    HMODULE hKernel32 = GetModuleHandle(TEXT("kernel32.dll"));
    if (hKernel32) {
        GetCurrentThreadStackLimits_t pGetCurrentThreadStackLimits =
            (GetCurrentThreadStackLimits_t)GetProcAddress(hKernel32, "GetCurrentThreadStackLimits");
        if (pGetCurrentThreadStackLimits) {
            pGetCurrentThreadStackLimits(&stackLow, &stackHigh);
            // Check if the address falls within the stack boundaries.
            if ((ULONG_PTR)address >= stackLow && (ULONG_PTR)address <= stackHigh)
                return "Stack Segment";
        }
    }
    
    // If the region belongs to the image (the executable module)...
    if (mbi.Type == MEM_IMAGE) {
        // Use protection flags to guess if it is code or data.
        if (mbi.Protect & (PAGE_EXECUTE | PAGE_EXECUTE_READ | PAGE_EXECUTE_READWRITE | PAGE_EXECUTE_WRITECOPY))
            return "Code Segment";
        else
            return "Data Segment (part of the executable image)";
    }
    
    // If it is private memory, most likely from a heap allocation.
    if (mbi.Type == MEM_PRIVATE) {
        return "Heap Segment";
    }

    return "Unknown Segment";
}

//
// Example usage:
//  - A local variable (should be on the stack)
//  - A heap variable (allocated with new)
//  - A global variable (in the image)
//
int globalData = 123;    // Global initialized variable (Data Segment)
static int globalBSS;    // Global uninitialized variable (BSS, but part of the image)

int main() {
    // Local (stack) variable
    int localVar = 42;
    std::cout << "Address of localVar: " << &localVar 
              << " -> " << getMemorySegment(&localVar) << "\n";

    // Dynamically allocated (heap) variable
    int* heapVar = new int(100);
    std::cout << "Address of heapVar: " << heapVar 
              << " -> " << getMemorySegment(heapVar) << "\n";
    delete heapVar;

    // Global initialized variable
    std::cout << "Address of globalData: " << &globalData 
              << " -> " << getMemorySegment(&globalData) << "\n";

    // Global uninitialized variable (BSS)
    std::cout << "Address of globalBSS: " << &globalBSS 
              << " -> " << getMemorySegment(&globalBSS) << "\n";

    // Function pointer (code segment)
    void (*funcPtr)() = []() { std::cout << "Inside function.\n"; };
    std::cout << "Address of funcPtr: " << reinterpret_cast<void*>(funcPtr)
              << " -> " << getMemorySegment(reinterpret_cast<void*>(funcPtr)) << "\n";

    return 0;
}
