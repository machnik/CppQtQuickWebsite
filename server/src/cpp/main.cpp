#include <atomic>
#include <iostream>
#include <thread>

std::atomic<bool> running(true);

void run()
{
}

int main()
{
    std::thread worker(run);

    std::cout << "Press enter to exit..." << std::endl;
    std::cin.get();

    running = false;

    worker.join();

    return 0;
}
