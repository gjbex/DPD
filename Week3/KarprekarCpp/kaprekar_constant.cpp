#include <algorithm>
#include <array>
#include <functional>
#include <iostream>
#include <set>
#include <stdexcept>

/*
 * Program to compute the Kaprekar constant for a given number.
 * The number should have four digits, and at least two of them should be
 * distinct.
 */

using NumberRepr = std::array<char,4>;

NumberRepr int2number(int n);
int number2int(NumberRepr number);
bool is_eligible(int n);
int make_small(int n);
int make_large(int n);

int main(int argc, char* argv[]) {
    if (argc != 2) {
        std::cerr << "### error: usage " << argv[0] << " <n>" << std::endl;
        std::exit(1);
    }
    int n {0};
    try {
        n = std::stoi(argv[1]);
    } catch(std::invalid_argument&) {
        std::cerr << "### error: argument should be an integer" << std::endl;
        std::exit(2);
    }
    if (!is_eligible(n)) {
        std::cerr << "### error: 0 < n < 10000 and should have at least "
                  << "two distinct digits" << std::endl;
        std::exit(3);
    }
    int original_n {n};
    int previous_small = make_small(n);
    for (int nr_steps = 0; ; ++nr_steps) {
        int large {make_large(n)};
        n = large - previous_small;
        int small {make_small(n)};
        if (small == previous_small) {
            std::cout << original_n << " " << nr_steps << " " << n << std::endl;
            return 0;
        }
        previous_small = small;
    }
    return 0;
}

NumberRepr int2number(int n) {
    NumberRepr number;
    for (int i = 3; i >= 0; --i) {
        number[i] = static_cast<char>('0' + (n % 10));
        n /= 10;
    }
    return number;
}

int number2int(NumberRepr number) {
    int n {0};
    int order {1000};
    for (int i = 0; i < 4; ++i) {
        n += order*(number[i] - '0');
        order /= 10;
    }
    return n;
}

bool is_eligible(int n) {
    if (n < 0 || n > 9999)
        return false;
    std::set<char> digits;
    for (const auto& digit: int2number(n))
        digits.insert(digit);
    return digits.size() >= 2;
}

int make_small(int n) {
    NumberRepr number {int2number(n)};
    std::sort(number.begin(), number.end());
    return number2int(number);
}

int make_large(int n) {
    NumberRepr number {int2number(n)};
    std::sort(number.begin(), number.end(), std::greater<char>());
    return number2int(number);
}
