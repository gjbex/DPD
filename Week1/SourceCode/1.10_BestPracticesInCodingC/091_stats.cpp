#include <iostream>
#include "090_stats.h"

int main() {
    Stats stats;
    for (int i = 0; i < 10; i++)
        stats.add(5.0);
    stats.n = 5;
    std::cout << stats.avg() << std::endl;
    return 0;
}
